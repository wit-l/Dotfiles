# Proxy helpers for PowerShell.
# proxy_on / proxy_off / proxy_status  (aliases: spr / cpr / gpr)

function proxy_on {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]$ProxyUrl = 'http://127.0.0.1:7890',

        [Parameter(Position = 1)]
        [string]$NoProxy
    )

    # Many tools honor only one casing; set both to be safe.
    $env:HTTP_PROXY = $ProxyUrl
    $env:HTTPS_PROXY = $ProxyUrl
    $env:http_proxy = $ProxyUrl
    $env:https_proxy = $ProxyUrl
    $env:ALL_PROXY = $ProxyUrl
    $env:all_proxy = $ProxyUrl

    if ($PSBoundParameters.ContainsKey('NoProxy')) {
        $env:NO_PROXY = $NoProxy
        $env:no_proxy = $NoProxy
    }

    Write-Host "proxy on: $ProxyUrl"
    if ($env:NO_PROXY) {
        Write-Host "NO_PROXY: $env:NO_PROXY"
    }
}

function proxy_off {
    foreach ($name in @(
            'HTTP_PROXY', 'HTTPS_PROXY', 'ALL_PROXY', 'NO_PROXY',
            'http_proxy', 'https_proxy', 'all_proxy', 'no_proxy'
        )) {
        Remove-Item -Path "Env:$name" -ErrorAction SilentlyContinue
    }
    Write-Host 'proxy off'
}

function proxy_status {
    $names = @(
        'HTTP_PROXY', 'HTTPS_PROXY', 'http_proxy', 'https_proxy',
        'ALL_PROXY', 'all_proxy', 'NO_PROXY', 'no_proxy'
    )
    foreach ($name in $names) {
        $value = [Environment]::GetEnvironmentVariable($name, 'Process')
        if ([string]::IsNullOrEmpty($value)) {
            $value = '(unset)'
        }
        Write-Host "${name}=${value}"
    }
}

Set-Alias -Name 'spr' -Value 'proxy_on' -Force
Set-Alias -Name 'gpr' -Value 'proxy_status' -Force
Set-Alias -Name 'cpr' -Value 'proxy_off' -Force
