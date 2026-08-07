#!/hint/zsh
# WSL → Windows 主机 Clash Verge 代理转发
#
# 原理：WSL NAT 模式下，主机 IP 即 WSL 默认网关（172.16.0.0/12 网段）。
# 主机 Clash Verge Rev 开启 allow-lan 后监听 0.0.0.0:7890，
# WSL 内通过此端口走代理；流量由 mihomo 进程发起。
#
# 仅在 WSL NAT 模式下自动启用：
#   - Mirrored 模式下 WSL 与主机共享网络栈，无需此代理转发，兼容性差，通常无法使用主机VPN
#   - Bridged 模式下 WSL 直接获取 LAN IP，也无需此代理转发

# 判断是否处于 WSL NAT 模式：
#   1. 必须在 WSL 内
#   2. 默认路由网关存在于 172.16.0.0/12 网段（NAT 网段）
_wsl_is_nat_mode() {
    [[ -z "$WSL_DISTRO_NAME" ]] && [[ ! -f /proc/sys/fs/binfmt_misc/WSLInterop ]] && return 1
    local gw
    gw=$(ip route show 2>/dev/null | awk '/^default/ {print $3; exit}')
    [[ -z "$gw" ]] && return 1
    # NAT 模式默认网关在 172.16.0.0/12 网段
    [[ "$gw" =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. ]]
}

# 自动设置代理变量
if _wsl_is_nat_mode; then
    _wsl_hostip=$(ip route show 2>/dev/null | awk '/^default/ {print $3; exit}')
    if [[ -n "$_wsl_hostip" ]]; then
        export http_proxy="http://$_wsl_hostip:7890"
        export https_proxy="$http_proxy"
        export HTTP_PROXY="$http_proxy"
        export HTTPS_PROXY="$http_proxy"
        export no_proxy="localhost,127.0.0.1,::1,$_wsl_hostip,.local,.internal,.lan"
        export NO_PROXY="$no_proxy"
        # all_proxy/ALL_PROXY 走 socks5（mihomo mixed-port 同时支持 HTTP+SOCKS5）
        export all_proxy="socks5://$_wsl_hostip:7890"
        export ALL_PROXY="$all_proxy"
    fi
    unset _wsl_hostip
fi

# 关闭代理
proxy_off() {
    unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY \
          all_proxy ALL_PROXY no_proxy NO_PROXY
    echo "proxy off"
}

# 重新打开代理（主机 IP 可能变化，比如换网络；或非 NAT 模式下强制启用）
proxy_on() {
    local hostip
    hostip=$(ip route show 2>/dev/null | awk '/^default/ {print $3; exit}')
    if [[ -z "$hostip" ]]; then
        echo "proxy on FAILED: cannot detect host IP"
        return 1
    fi
    export http_proxy="http://$hostip:7890"
    export https_proxy="$http_proxy"
    export HTTP_PROXY="$http_proxy"
    export HTTPS_PROXY="$http_proxy"
    export no_proxy="localhost,127.0.0.1,::1,$hostip,.local,.internal,.lan"
    export NO_PROXY="$no_proxy"
    export all_proxy="socks5://$hostip:7890"
    export ALL_PROXY="$all_proxy"
    echo "proxy on: $http_proxy"
}

# 查看代理状态
proxy_status() {
    if [[ -n "$http_proxy" ]]; then
        echo "proxy ON  -> $http_proxy"
        echo "  no_proxy: $no_proxy"
    else
        echo "proxy OFF"
    fi
}

# 查看当前 WSL 网络模式
proxy_mode() {
    if [[ -z "$WSL_DISTRO_NAME" ]] && [[ ! -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
        echo "not in WSL"
        return
    fi
    local gw
    gw=$(ip route show 2>/dev/null | awk '/^default/ {print $3; exit}')
    if [[ -z "$gw" ]]; then
        echo "WSL: no default route"
        return
    fi
    if [[ "$gw" =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. ]]; then
        echo "WSL NAT mode (gw=$gw)"
    else
        echo "WSL non-NAT mode (gw=$gw) - proxy not auto-enabled"
    fi
}
