# Install chrisant996/clink-gizmos scripts (upstream lives outside dotfiles).
# Clones to C:\Software\clink\gizmos and symlinks selected .lua files into this profile.

param(
    [string]$Repo,
    [string[]]$Files = @('tilde_autoexpand.lua'),
    [string]$Proxy = 'http://127.0.0.1:7890',
    [switch]$NoProxy
)

$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\_install-common.ps1" -Proxy $Proxy -NoProxy:$NoProxy

if (-not $Repo) { $Repo = Join-Path $ClinkSoftwareRoot 'gizmos' }
$ProfileDir = $PSScriptRoot

Ensure-GitRepo -Repo $Repo -CloneUrl 'https://github.com/chrisant996/clink-gizmos.git'

foreach ($name in $Files) {
    New-ProfileSymlink -ProfileDir $ProfileDir -Name $name -Target (Join-Path $Repo $name)
}

Write-Host "Done. Linked $($Files.Count) file(s) from clink-gizmos."
