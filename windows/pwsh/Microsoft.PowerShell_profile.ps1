$PSStyle.FileInfo.Directory="`e[34;1m"
$CODE="D:\Users\witty\Documents\code"
New-Alias -Name "vi" -Value "nvim"
New-Alias -Name "ghl" -Value "Get-Help"
Set-Alias -Name "j" -Value "Invoke-ZLocation"
$MSYS2_SOFTWARE="D:\msys64\home\witty\.config\.local\zinit\plugins"
$ENV:PATH="$MSYS2_SOFTWARE\BurntSushi---ripgrep\ripgrep-14.1.0-x86_64-pc-windows-gnu;$MSYS2_SOFTWARE\eza-community---eza;$MSYS2_SOFTWARE\sharkdp---bat\bat-v0.24.0-x86_64-pc-windows-gnu;$MSYS2_SOFTWARE\junegunn---fzf;$MSYS2_SOFTWARE\sharkdp---fd\fd-v9.0.0-x86_64-pc-windows-gnu;"+$ENV:PATH

if (Test-Path -Path $MSYS2_SOFTWARE\BurntSushi---ripgrep\ripgrep-14.1.0-x86_64-pc-windows-gnu\complete\_rg.ps1) {
  . "$MSYS2_SOFTWARE\BurntSushi---ripgrep\ripgrep-14.1.0-x86_64-pc-windows-gnu\complete\_rg.ps1"
}
if (Test-Path -Path $MSYS2_SOFTWARE\sharkdp---bat\bat-v0.24.0-x86_64-pc-windows-gnu\autocomplete\_bat.ps1) {
  . "$MSYS2_SOFTWARE\sharkdp---bat\bat-v0.24.0-x86_64-pc-windows-gnu\autocomplete\_bat.ps1"
}
if (Test-Path -Path $MSYS2_SOFTWARE\sharkdp---fd\fd-v9.0.0-x86_64-pc-windows-gnu\autocomplete\fd.ps1) {
  . "$MSYS2_SOFTWARE\sharkdp---fd\fd-v9.0.0-x86_64-pc-windows-gnu\autocomplete\fd.ps1"
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
    eza.exe -al @args
}

function glog {
    git log --decorate --graph --oneline @args
}

function ls_ {
    eza.exe  @args
}

function ll {
    eza.exe  -l @args
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

# function fzf {
#     fzf.exe -e --preview 'bat --color=always --style=numbers --line-range=:500 {}' @args
# }

#------------------------------- Import Modules BEGIN -------------------------------
# Import-Module PSReadLine
#------------------------------- Import Modules END -------------------------------
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/montys.omp.json" | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/robbyrussell.omp.json" | Invoke-Expression
if (Test-Path -Path D:/msys64/home/witty/.config/.local/zinit/plugins/skywind3000---z.lua/z.lua) {
  Invoke-Expression (& { (lua D:/msys64/home/witty/.config/.local/zinit/plugins/skywind3000---z.lua/z.lua --init powershell enhanced fzf echo once) -join "`n" })
}

$_ZL_DATA="~/.config/.zlua"
$_ZL_ECHO=1
$_ZL_MATCH_MODE=1
$_ZL_ADD_ONCE=1
$_ZL_ZSH_NO_FZF=0
$_ZL_ROOT_MARKERS=".git,.svn,.hg,.root,package.json"
$_ZL_INT_SORT=1

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
# neofetch
