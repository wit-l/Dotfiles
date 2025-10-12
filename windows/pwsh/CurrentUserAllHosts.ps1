# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
$PSStyle.FileInfo.Directory="`e[34;1m"
starship init powershell | Invoke-Expression
# 初始化zoxide
zoxide init powershell | Out-String | Invoke-Expression
# 初始化fnm
fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
#------------------------------- Set Hot-keys BEGIN -------------------------------
# 设置预测文本来源为历史记录
Set-PSReadLineOption -PredictionSource History -HistorySearchCursorMovesToEnd -EditMode Emacs -PredictionViewStyle InlineView -BellStyle None 
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete
#------------------------------- Set Hot-keys END -------------------------------
#region mamba initialize
# !! Contents within this block are managed by 'mamba shell init' !!
$Env:MAMBA_ROOT_PREFIX = "D:\Software\miniforge3"
$Env:MAMBA_EXE = "D:\Software\miniforge3\Library\bin\mamba.exe"
(& $Env:MAMBA_EXE 'shell' 'hook' -s 'powershell' -r $Env:MAMBA_ROOT_PREFIX) | Out-String | Invoke-Expression
#endregion
$Env:HTTPS_PROXY = "http://127.0.0.1:7890"
$Env:HTTP_PROXY = "http://127.0.0.1:7890"
