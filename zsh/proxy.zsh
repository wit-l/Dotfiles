#!/hint/zsh
# WSL -> Windows 主机 Clash Verge 代理转发
#
# 支持两种 WSL 网络模式：
#   - Mirrored（镜像模式，WSL2 新特性，推荐）：
#       WSL 与 Windows 共享网络栈。代理直接走 127.0.0.1:7890。
#       硬特征：存在 loopback0 接口（NAT 模式不会创建此接口）
#   - NAT（旧模式，Hyper-V 默认）：
#       WSL 有独立网络栈，localhost 不互通（但 localhostForwarding 仍可
#       把 127.0.0.1 转发到主机，所以不能用 127.0.0.1 可达性判断模式）。
#       主机 IP 即 WSL 默认网关（172.16.0.0/12 段），需要 Clash 开启
#       allow-lan 监听 0.0.0.0:7890，WSL 通过网关 IP 访问。
#       注意：NAT 模式默认 hostAddressLoopback=true，会在 lo 上绑定
#       10.255.255.254/32（用于回环访问主机），这并非镜像模式特征，
#       不能用作模式判据。
#
# 模式判断优先级（不依赖 127.0.0.1 端口探测，避免 localhostForwarding 干扰）：
#   1. 是否在 WSL 内
#   2. 读 /mnt/c/Users/*/.wslconfig 的 networkingMode 字段（最权威）
#   3. 网卡硬特征：存在 loopback0 接口（Mirrored 独有，NAT 绝不创建）
#   4. NAT 兜底：默认网关在 172.16.0.0/12 段
#   5. 其它（Bridged 等）：不自动设置代理
#
# 代理可用性检测：
#   即使模式判断正确，Clash 可能没启动或未开 allow-lan。
#   设置代理变量前先 TCP 探测代理端口，不可用则不设置（直连）。
#   否则程序会尝试连死代理，所有请求都要等超时，比直连慢得多。

# 判断是否在 WSL 内
_wsl_in_wsl() {
    [[ -n "$WSL_DISTRO_NAME" ]] || [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]
}

# 读取 .wslconfig 中的 networkingMode 配置
# 返回：mirrored / nat / 空（读取失败或未配置）
# 注意：只读取，绝不修改原文件
_wsl_read_wslconfig_mode() {
    local cfg line mode=""
    # 扫描 /mnt/c/Users/*/.wslconfig，跳过系统目录
    for cfg in /mnt/c/Users/*/.wslconfig; do
        [[ -f "$cfg" ]] || continue
        case "$cfg" in
            */All\ Users/*|*/Default*/*|*/Public/*) continue ;;
        esac
        # networkingMode 可能写在 [wsl2] 或 [experimental] 下，取第一行匹配
        line=$(grep -iE '^[[:space:]]*networkingMode[[:space:]]*=' "$cfg" 2>/dev/null | head -1)
        [[ -z "$line" ]] && continue
        # 去掉 "networkingMode =" 前缀，再清理空白和引号
        mode=${line#*=}
        mode=${mode// /}
        mode=${mode//	/}
        mode=${mode//\"/}
        mode=${mode//\'/}
        mode=$(echo "$mode" | tr '[:upper:]' '[:lower:]')
        break
    done
    case "$mode" in
        mirrored|mirror) echo "mirrored" ;;
        nat)             echo "nat" ;;
        *)               echo "" ;;
    esac
}

# 判断是否为 WSL 镜像模式（Mirrored）
# 依据：.wslconfig 配置 或 网卡硬特征（loopback0 接口）
# 注意：lo 上 10.255.255.254/32 是 NAT 模式 hostAddressLoopback=true 的默认行为，
#       不能作为镜像模式判据，否则会把 NAT 误判为镜像
_wsl_is_mirrored_mode() {
    _wsl_in_wsl || return 1
    # 依据 1：.wslconfig 显式配置
    local cfg_mode
    cfg_mode=$(_wsl_read_wslconfig_mode)
    [[ "$cfg_mode" == "mirrored" ]] && return 0
    [[ "$cfg_mode" == "nat" ]] && return 1
    # 依据 2：网卡硬特征 - 存在 loopback0 接口（Mirrored 模式独有，NAT 绝不创建）
    if ip link show loopback0 >/dev/null 2>&1; then
        return 0
    fi
    return 1
}

# 判断是否为 WSL NAT 模式
# 依据：非镜像 + 默认网关在 172.16.0.0/12 段
_wsl_is_nat_mode() {
    _wsl_in_wsl || return 1
    _wsl_is_mirrored_mode && return 1
    local gw
    gw=$(ip route show 2>/dev/null | awk '/^default/ {print $3; exit}')
    [[ -z "$gw" ]] && return 1
    [[ "$gw" =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. ]]
}

# 根据当前模式确定代理 host（不探测可用性）
# 输出：代理 host IP；镜像模式输出 127.0.0.1，NAT 模式输出网关 IP
_wsl_proxy_host() {
    if _wsl_is_mirrored_mode; then
        echo "127.0.0.1"
    else
        ip route show 2>/dev/null | awk '/^default/ {print $3; exit}'
    fi
}

# 检测 TCP 端口是否可达（带超时，避免卡住 shell 启动）
# 用法：_wsl_port_open host port [timeout_secs]
# 注意：/dev/tcp 是 bash 特性，zsh 不支持，必须通过 bash -c 调用
_wsl_port_open() {
    local host="$1" port="${2:-7890}" secs="${3:-2}"
    [[ -z "$host" ]] && return 1
    # 端口开立即返回 0；未开 RST 立即返回非 0；超时返回 124
    if command -v timeout >/dev/null 2>&1; then
        timeout "$secs" bash -c 'true < /dev/tcp/'"$host"'/'"$port" 2>/dev/null
    else
        bash -c 'true < /dev/tcp/'"$host"'/'"$port" 2>/dev/null
    fi
}

# 统一设置代理变量（传入 host）
_wsl_set_proxy() {
    local host="$1"
    if [[ -z "$host" ]]; then
        echo "proxy auto: cannot determine proxy host, skipped" >&2
        return 1
    fi
    export http_proxy="http://$host:7890"
    export https_proxy="$http_proxy"
    export HTTP_PROXY="$http_proxy"
    export HTTPS_PROXY="$http_proxy"
    export no_proxy="localhost,127.0.0.1,::1,$host,.local,.internal,.lan"
    export NO_PROXY="$no_proxy"
    export all_proxy="socks5://$host:7890"
    export ALL_PROXY="$all_proxy"
    return 0
}

# 自动根据 WSL 网络模式设置代理（含可用性检测）
# 仅当：1) 在 WSL 内 2) 模式可识别 3) 代理端口可达 时才设置代理变量
if _wsl_in_wsl; then
    _wsl_proxy_host_ip=$(_wsl_proxy_host)
    if [[ -n "$_wsl_proxy_host_ip" ]]; then
        if _wsl_port_open "$_wsl_proxy_host_ip" 7890 2; then
            _wsl_set_proxy "$_wsl_proxy_host_ip" || true
        else
            # 代理不可用：不设置代理变量，避免程序连死代理超时
            # 国内资源直连正常；国外资源会慢，但比全部超时好
            true
        fi
    fi
    unset _wsl_proxy_host_ip
fi

# 关闭代理
proxy_off() {
    unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY \
          all_proxy ALL_PROXY no_proxy NO_PROXY
    echo "proxy off"
}

# 重新打开代理（根据当前模式自动选择 host；也允许手动指定 host）
# 会探测代理端口，不可用时提示但不强制设置
proxy_on() {
    local host="$1"
    if [[ -z "$host" ]]; then
        host=$(_wsl_proxy_host)
    fi
    if [[ -z "$host" ]]; then
        echo "proxy on FAILED: cannot detect proxy host"
        return 1
    fi
    if ! _wsl_port_open "$host" 7890 2; then
        echo "proxy on WARNING: $host:7890 not reachable (Clash not running or allow-lan off)"
        echo "  set proxy anyway? use: proxy_on_force $host"
        return 1
    fi
    _wsl_set_proxy "$host"
    echo "proxy on: $http_proxy"
}

# 强制设置代理（不探测可用性，用于代理暂时不可达但想预设变量的场景）
proxy_on_force() {
    local host="$1"
    if [[ -z "$host" ]]; then
        host=$(_wsl_proxy_host)
    fi
    if [[ -z "$host" ]]; then
        echo "proxy on FAILED: cannot detect proxy host"
        return 1
    fi
    _wsl_set_proxy "$host"
    echo "proxy on (forced): $http_proxy"
}

# 查看代理状态
proxy_status() {
    if [[ -n "$http_proxy" ]]; then
        echo "proxy ON  -> $http_proxy"
        echo "  no_proxy: $no_proxy"
    else
        echo "proxy OFF"
        # 探测代理是否可用，给用户提示
        local host
        host=$(_wsl_proxy_host)
        if [[ -n "$host" ]]; then
            if _wsl_port_open "$host" 7890 1; then
                echo "  (代理可用 $host:7890，使用 proxy_on 开启)"
            else
                echo "  (代理不可用 $host:7890，Clash 未运行或未开 allow-lan)"
            fi
        fi
    fi
}

# 查看当前 WSL 网络模式（用于排错，输出判断依据）
proxy_mode() {
    if ! _wsl_in_wsl; then
        echo "not in WSL"
        return
    fi
    local gw cfg_mode host
    gw=$(ip route show 2>/dev/null | awk '/^default/ {print $3; exit}')
    cfg_mode=$(_wsl_read_wslconfig_mode)
    host=$(_wsl_proxy_host)

    local has_loopback0=0 has_loopback_ip=0
    ip link show loopback0 >/dev/null 2>&1 && has_loopback0=1
    ip -4 addr show lo 2>/dev/null | grep -q '10\.255\.255\.254' && has_loopback_ip=1

    if _wsl_is_mirrored_mode; then
        echo "WSL MIRRORED mode (shared network stack, proxy -> 127.0.0.1)"
        [[ -n "$cfg_mode" ]] && echo "  -> .wslconfig networkingMode=$cfg_mode"
        [[ "$has_loopback0" -eq 1 ]] && echo "  -> detected: loopback0 interface present"
        [[ -n "$gw" ]] && echo "  (gw=$gw, ignored for mode detection)"
    elif [[ -n "$gw" ]] && [[ "$gw" =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. ]]; then
        echo "WSL NAT mode (gw=$gw) - proxy via host gateway IP"
        [[ -n "$cfg_mode" ]] && echo "  -> .wslconfig networkingMode=$cfg_mode"
        [[ "$has_loopback_ip" -eq 1 ]] && echo "  -> lo has 10.255.255.254/32 (hostAddressLoopback=true, NAT default, NOT mirrored indicator)"
    elif [[ -z "$gw" ]]; then
        echo "WSL: no default route"
    else
        echo "WSL non-NAT/non-Mirrored mode (gw=$gw) - proxy not auto-enabled"
    fi

    # 代理可用性
    if [[ -n "$host" ]]; then
        if _wsl_port_open "$host" 7890 1; then
            echo "  proxy reachable: $host:7890 OK"
        else
            echo "  proxy NOT reachable: $host:7890 (Clash 未运行或未开 allow-lan)"
        fi
    fi

    # 当前代理变量状态
    if [[ -n "$http_proxy" ]]; then
        echo "  current: proxy ON -> $http_proxy"
    else
        echo "  current: proxy OFF (直连)"
    fi
}
