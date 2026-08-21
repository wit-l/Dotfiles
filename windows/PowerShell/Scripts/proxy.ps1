# Proxy helpers for PowerShell.
# Aliases: spr / cpr

function Set-Proxy {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$ProxyUrl,

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

    Write-Host "代理已设置为: $ProxyUrl"
    if ($env:NO_PROXY) {
        Write-Host "NO_PROXY: $env:NO_PROXY"
    }
}

function Clear-Proxy {
    foreach ($name in @(
            'HTTP_PROXY', 'HTTPS_PROXY', 'ALL_PROXY', 'NO_PROXY',
            'http_proxy', 'https_proxy', 'all_proxy', 'no_proxy'
        )) {
        Remove-Item -Path "Env:$name" -ErrorAction SilentlyContinue
    }
    Write-Host '代理环境变量已清除。'
}

Set-Alias -Name 'spr' -Value 'Set-Proxy' -Force
Set-Alias -Name 'cpr' -Value 'Clear-Proxy' -Force
