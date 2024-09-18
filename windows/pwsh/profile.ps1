# load completion function
$cmp_paths = @(
    # "D:\Software\zoxide\completions\_zoxide.ps1",
    # "D:\Software\MsysSoftware\BurntSushi---ripgrep\ripgrep\complete\_rg.ps1",
    # "D:\Software\MsysSoftware\sharkdp---bat\bat\autocomplete\_bat.ps1",
    # "D:\Software\MsysSoftware\sharkdp---fd\fd\autocomplete\fd.ps1",
    "D:\Users\witty\Documents\PowerShell\Scripts"
)

foreach ($cmp_path in $cmp_paths) {
    if (Test-Path -Path $cmp_path -PathType Container) { # 文件夹则使其中的ps1均生效
        Get-ChildItem -Path $cmp_path -Filter *.ps1 | ForEach-Object {
            . $_.FullName
        }
    }elseif (Test-Path -Path $cmp_path) {
        . $cmp_path
    }
}
Remove-Variable -Name cmp_paths,cmp_path

#------------------------------- Import Modules BEGIN -------------------------------
# Import-Module PSCompletions
#------------------------------- Import Modules END -------------------------------
# Starship(faster)
starship init powershell | Invoke-Expression
# 初始化zoxide
zoxide init powershell | Out-String | Invoke-Expression
# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:(too slow)
# Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
# Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
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
