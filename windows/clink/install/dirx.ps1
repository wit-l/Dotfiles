# Install chrisant996/dirx (prebuilt release; used by clink-fzf for relative paths).
# Installs dirx.exe to C:\Software and adds that directory to user PATH.

param(
    [string]$InstallDir,
    [string]$Version = 'v0.31',
    [string]$Proxy = 'http://127.0.0.1:7890',
    [switch]$NoProxy
)

$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\_install-common.ps1" -Proxy $Proxy -NoProxy:$NoProxy

if (-not $InstallDir) { $InstallDir = $SoftwareRoot }
$exe = Join-Path $InstallDir 'dirx.exe'
$legacyExe = Join-Path $ClinkSoftwareRoot 'dirx\dirx.exe'

if (Test-Path -LiteralPath $exe) {
    Write-Host "dirx already installed: $exe"
    Add-UserPathEntry -Dir $InstallDir
    exit 0
}

if (Test-Path -LiteralPath $legacyExe) {
    Write-Host "Migrating dirx from $legacyExe ..."
    if (-not (Test-Path -LiteralPath $InstallDir)) {
        New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    }
    Copy-Item -LiteralPath $legacyExe -Destination $exe -Force
    Add-UserPathEntry -Dir $InstallDir
    Write-Host "Installed dirx -> $exe"
    exit 0
}

if (-not (Test-Path -LiteralPath $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

$zipName = "dirx-$Version.zip"
$url = "https://github.com/chrisant996/dirx/releases/download/$Version/$zipName"
$zip = Join-Path $env:TEMP $zipName
$extract = Join-Path $env:TEMP "dirx-$Version"

Write-Host "Downloading $url ..."
Use-InstallProxy
if ($script:InstallProxy) {
    curl.exe -fsSL -x $script:InstallProxy -o $zip $url
} else {
    curl.exe -fsSL -o $zip $url
}

if (Test-Path -LiteralPath $extract) {
    Remove-Item -LiteralPath $extract -Recurse -Force
}
Expand-Archive -LiteralPath $zip -DestinationPath $extract -Force

$found = Get-ChildItem -LiteralPath $extract -Recurse -Filter 'dirx.exe' | Select-Object -First 1
if (-not $found) {
    throw "dirx.exe not found in $zip"
}

Copy-Item -LiteralPath $found.FullName -Destination $exe -Force
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $extract -Recurse -Force -ErrorAction SilentlyContinue

Add-UserPathEntry -Dir $InstallDir
Write-Host "Installed dirx -> $exe"
Write-Host 'Restart the terminal so PATH picks up dirx.exe.'
