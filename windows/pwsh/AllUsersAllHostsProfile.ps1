# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
$PSStyle.FileInfo.Directory="`e[34;1m"
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
