# Install skywind3000/z.lua for Clink (upstream lives outside dotfiles).
# Creates z.lua + z.cmd symlinks in this profile directory.

$ErrorActionPreference = 'Stop'

$ZRepo = if ($env:Z_LUA_HOME) { $env:Z_LUA_HOME } else { 'C:\Software\z.lua' }
$ProfileDir = $PSScriptRoot

function Ensure-ZRepo {
    if (Test-Path -LiteralPath (Join-Path $ZRepo '.git') -PathType Container) {
        Write-Host "Updating $ZRepo ..."
        git -C $ZRepo pull --ff-only
        return
    }
    $parent = Split-Path -Parent $ZRepo
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    Write-Host "Cloning z.lua into $ZRepo ..."
    git clone https://github.com/skywind3000/z.lua.git $ZRepo
}

Ensure-ZRepo

foreach ($name in @('z.lua', 'z.cmd')) {
    $link = Join-Path $ProfileDir $name
    $target = Join-Path $ZRepo $name
    if (-not (Test-Path -LiteralPath $target)) {
        throw "Missing upstream file: $target"
    }
    if (Test-Path -LiteralPath $link) {
        Remove-Item -LiteralPath $link -Force
    }
    New-Item -ItemType SymbolicLink -Path $link -Target $target | Out-Null
    Write-Host "Linked $name -> $target"
}

Write-Host 'Done. Ensure %CLINK_PROFILE% is on PATH so z.cmd is callable.'
