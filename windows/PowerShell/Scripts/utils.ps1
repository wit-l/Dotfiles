# General utilities for PowerShell.

function mkcd {
    param (
        [Parameter(Mandatory = $true)]
        [string]$dir
    )
    if (-not (Test-Path -Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
    Set-Location -Path $dir
}

function which {
    param([String]$name)
    $cmd = Get-Command $name -ErrorAction SilentlyContinue
    if (-not $cmd) {
        Write-Host "${name}: not found"
        return
    }
    switch ($cmd.CommandType) {
        "Alias" { "{0}: Alias for ({1})" -f $cmd.Name, (which $cmd.Definition) }
        "Application" { $cmd.Source }
        "Cmdlet" { "{0}: {1} in module {2}" -f $cmd.Name, $cmd.CommandType, $cmd.Source }
        "Function" { "{0}: {1} in module {2}" -f $cmd.Name, $cmd.CommandType, $cmd.Source }
        default { $cmd }
    }
}
