# load completion function
$cmp_paths = @(
    # "D:\Software\zoxide\completions\_zoxide.ps1",
    # "D:\Software\MsysSoftware\BurntSushi---ripgrep\ripgrep\complete\_rg.ps1",
    # "D:\Software\MsysSoftware\sharkdp---bat\bat\autocomplete\_bat.ps1",
    # "D:\Software\MsysSoftware\sharkdp---fd\fd\autocomplete\fd.ps1",
    # "D:\Users\witty\Documents\PowerShell\Completions\fnm.ps1",
    "D:\Users\witty\Documents\PowerShell\Scripts"
)
$env:EDITOR="nvim"
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

# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:(too slow)
# Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
# Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
