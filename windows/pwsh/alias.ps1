New-Alias -Name "vi" -Value "nvim"
New-Alias -Name "v" -Value "nvim"
New-Alias -Name "ghl" -Value "Get-Help"
New-Alias -Name "lg" -Value "lazygit"

function grv {
    git remote -v @args
}

function gs {
    git status @args
}

function gss {
    git status --short @args
}

function gpo {
    git push @args
}

function gpl {
    git pull @args
}

function ga {
    git add @args
}

function lla {
    eza.exe -al --icons=auto @args
}

function glog {
    git log --decorate --graph --oneline @args
}

function ls_ {
    eza.exe --icons=auto @args
}

function ll {
    eza.exe  -l --icons=auto @args
}

Set-Alias -Name ls -Value ls_

function mkcd {
    param (
        [Parameter(Mandatory=$true)]
        [string]$dir
    )
    if (-not (Test-Path -Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
    Set-Location -Path $dir
}
# Utilities
function which {
    param([String]$name)
    $cmd = Get-Command $name
    switch ($cmd.CommandType) {
        "Alias"     { "{0}: Alias for ({1})" -f $cmd.Name, (which $cmd.Definition) }
        "Application" { $cmd.Source }
        "Cmdlet"    { "{0}: {1} in module {2}" -f $cmd.Name, $cmd.CommandType, $cmd.Source }
        "Function"  { "{0}: {1} in module {2}" -f $cmd.Name, $cmd.CommandType, $cmd.Source }
        default     { $cmd }
    }
}
