# Aliases and git/eza wrappers for PowerShell.

New-Alias -Name "vi" -Value "nvim" -Force
New-Alias -Name "v" -Value "nvim" -Force
New-Alias -Name "ghl" -Value "Get-Help" -Force
New-Alias -Name "lg" -Value "lazygit" -Force

function gb {
    git branch @args
}

function gbvv {
    git branch -vv @args
}

function gbd {
    git branch --delete @args
}

function gbD {
    git branch --delete --force @args
}

function gr {
    git remote @args
}

function grv {
    git remote -v @args
}

function grs {
    git remote show @args
}

function gs {
    git status @args
}

function gss {
    git status --short @args
}

function gsw {
    git switch @args
}

function gswc {
    git switch --create @args
}

function gpo {
    git push origin @args
}

function gco {
    git checkout @args
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
    eza.exe -l --icons=auto @args
}

Set-Alias -Name ls -Value ls_ -Force
