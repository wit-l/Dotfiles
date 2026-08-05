#!/hint/zsh
# WSL → Windows 主机 Clash Verge 代理转发
#
# 原理：WSL NAT 模式下，主机 IP 即 WSL 默认网关。
# 主机 Clash Verge Rev 开启 allow-lan 后监听 0.0.0.0:7890，
# WSL 内通过此端口走代理；流量由 mihomo 进程发起，会被 aTrust 放行。
#
# 仅在 WSL 内启用，避免在原生 Linux 主机上误启用。
if [[ -n "$WSL_DISTRO_NAME" ]] || [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
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

    # 关闭代理
    proxy_off() {
        unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY \
              all_proxy ALL_PROXY no_proxy NO_PROXY
        echo "proxy off"
    }

    # 重新打开代理（主机 IP 可能变化，比如换网络）
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

    unset _wsl_hostip
fi
