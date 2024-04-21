# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

$PSStyle.FileInfo.Directory="`e[34;1m"
$Dot="D:\Users\witty\OneDrive - GiantHard\文档\PowerShell\Dotfiles"
New-Alias -Name "vi" -Value "nvim"
New-Alias -Name "ghl" -Value "Get-Help"
New-Alias -Name "j" -Value "_zlua"

if (Test-Path -Path D:\Software\MsysSoftware\BurntSushi---ripgrep\ripgrep\complete\_rg.ps1) {
    . "D:\Software\MsysSoftware\BurntSushi---ripgrep\ripgrep\complete\_rg.ps1"
}
if (Test-Path -Path D:\Software\MsysSoftware\sharkdp---bat\bat\autocomplete\_bat.ps1) {
    . "D:\Software\MsysSoftware\sharkdp---bat\bat\autocomplete\_bat.ps1"
}
if (Test-Path -Path D:\Software\MsysSoftware\sharkdp---fd\fd\autocomplete\fd.ps1) {
    . "D:\Software\MsysSoftware\sharkdp---fd\fd\autocomplete\fd.ps1"
}
if (Test-Path -Path D:\Users\witty\Documents\PowerShell\Scripts\UseLinuxTools.ps1) {
    . "D:\Users\witty\Documents\PowerShell\Scripts\UseLinuxTools.ps1"
}
function ji {
    _zlua -i @args
}

function jb {
    _zlua -b @args
}

function grv {
    git remote -v @args
}

function gs {
    git status @args
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
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
#------------------------------- Import Modules BEGIN -------------------------------
# Import-Module Terminal-Icons
#------------------------------- Import Modules END -------------------------------
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/montys.omp.json" | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/robbyrussell.omp.json" | Invoke-Expression

if (Test-Path -Path D:\Software\MsysSoftware\skywind3000---z.lua\z.lua) {
  Invoke-Expression (& { (lua D:\Software\MsysSoftware\skywind3000---z.lua\z.lua --init powershell enhanced fzf echo once) -join "`n" })
}
Set-Alias -Name "z" -Value "Invoke-ZLocation"
#------------------------------- Set Hot-keys BEGIN -------------------------------
# 设置预测文本来源为历史记录
Set-PSReadLineOption -PredictionSource History -HistorySearchCursorMovesToEnd -EditMode Vi -PredictionViewStyle InlineView -BellStyle None 
# 根据不同的 Vi 模式更改光标形状
function OnViModeChange {
    if ($args[0] -eq 'Command') {
        # 设置光标为竖线（bar）形状
        Write-Host -NoNewLine "`e[1 q"
    } else {
        # 设置光标为实心方块（filled box）形状
        Write-Host -NoNewLine "`e[5 q"
    }
}

# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange
# Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete

# 退出到Normal模式
Set-PSReadLineKeyHandler -Key "Ctrl+;" -Function ViCommandMode
# Emacs风格key-bindings
Set-PSReadLineKeyHandler -Key "Alt+b" -Function BackwardWord
Set-PSReadLineKeyHandler -Key "Alt+f" -Function ForwardWord
Set-PSReadLineKeyHandler -Key "Ctrl+b" -Function BackwardChar
Set-PSReadLineKeyHandler -Key "Ctrl+f" -Function ForwardChar
Set-PSReadLineKeyHandler -Key "Ctrl+e" -Function EndOfLine
Set-PSReadLineKeyHandler -Key "Ctrl+a" -Function BeginningOfLine
Set-PSReadLineKeyHandler -Key "Ctrl+u" -Function BackwardKillInput
Set-PSReadLineKeyHandler -Key "Ctrl+y" -Function Yank
Set-PSReadLineKeyHandler -Key "Ctrl+k" -Function KillLine
Set-PSReadLineKeyHandler -Key "Ctrl+h" -Function BackwardDeleteChar

# 历史搜索选择键绑定为p、n
Set-PSReadLineKeyHandler -Key "Ctrl+n" -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key "Ctrl+p" -Function HistorySearchBackward
# 删除前一个单词：Ctrl+w
Set-PSReadlineKeyHandler -Key "Ctrl+w" -Function BackwardDeleteWord
Set-PSReadlineKeyHandler -Key "Ctrl+c" -Function Copy
Set-PSReadLineKeyHandler -Key "Shift+LeftArrow" -Function SelectBackwardChar
Set-PSReadLineKeyHandler -Key "Shift+RightArrow" -Function SelectForwardChar
Set-PSReadLineKeyHandler -Key "Ctrl+Shift+LeftArrow" -Function SelectBackwardWord
Set-PSReadLineKeyHandler -Key "Ctrl+Shift+RightArrow" -Function SelectForwardWord
#------------------------------- Set Hot-keys END -------------------------------
