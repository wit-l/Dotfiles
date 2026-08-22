# Install chrisant996/clink-fzf (upstream lives outside dotfiles).
# Clones to C:\Software\clink\fzf and symlinks needed files into this profile.

param(
    [string]$Repo,
    [switch]$Minimal,
    [switch]$NoBindings,
    [string]$Proxy = 'http://127.0.0.1:7890',
    [switch]$NoProxy
)

$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\_install-common.ps1" -Proxy $Proxy -NoProxy:$NoProxy

if (-not $Repo) { $Repo = Join-Path $ClinkSoftwareRoot 'fzf' }
$ProfileDir = $PSScriptRoot

$AllFiles = @(
    'fzf.lua',
    'fzf_git.lua',
    'fzf_git_helper.cmd',
    'fzf_rg.lua',
    'fzf_rg.cmd'
)
$Files = if ($Minimal) { @('fzf.lua') } else { $AllFiles }

Ensure-GitRepo -Repo $Repo -CloneUrl 'https://github.com/chrisant996/clink-fzf.git'

foreach ($name in $Files) {
    New-ProfileSymlink -ProfileDir $ProfileDir -Name $name -Target (Join-Path $Repo $name)
}

if (-not $NoBindings) {
    if (Get-Command clink -ErrorAction SilentlyContinue) {
        clink set fzf.default_bindings true | Out-Null
        clink set fzf_git.default_bindings true | Out-Null
        Write-Host 'Enabled clink fzf.default_bindings and fzf_git.default_bindings.'
    } else {
        Write-Warning 'clink not in PATH; run manually:'
        Write-Warning '  clink set fzf.default_bindings true'
        Write-Warning '  clink set fzf_git.default_bindings true'
    }
}

Write-Host 'Done. Requires fzf.exe on PATH (or clink set fzf.exe_location).'
