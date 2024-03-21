$PSStyle.FileInfo.Directory="`e[34;1m"
$VIMRC="D:\software\vim\_vimrc"
$VIMRUNTIME="D:\software\vim\vim91"
$CODE="D:\Users\witty\Documents\code"
New-Alias -Name "vi" -Value "nvim"
New-Alias -Name "ghl" -Value "Get-Help"
. "D:\Software\ripgrep\complete\_rg.ps1"

function grv {
    git remote -v @args
}

function lla {
    ls.exe --color=always -al @args
}

function glog {
    git log --decorate --graph --oneline @args
}

function ls_ {
    ls.exe --color=auto @args
}

function ll {
    ls.exe --color=auto -l @args
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

function fzf {
    fzf.exe -e --preview 'bat --color=always --style=numbers --line-range=:500 {}' @args
}

#------------------------------- Import Modules BEGIN -------------------------------
# Import-Module PSReadLine
#------------------------------- Import Modules END -------------------------------
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/montys.omp.json" | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/robbyrussell.omp.json" | Invoke-Expression

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

Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange
# 设置 Tab 为菜单补全和 Intellisense
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete

# 设置 Ctrl+d 为退出 PowerShell
Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function ViExit

# 退出到Normal模式
Set-PSReadLineKeyHandler -Key "Alt+q" -Function ViCommandMode
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
# neofetch
