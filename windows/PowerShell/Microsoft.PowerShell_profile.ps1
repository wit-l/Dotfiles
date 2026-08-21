# load completion function
$cmp_paths = @(
  "C:\Users\$ENV:USERNAME\Documents\PowerShell\Scripts"
)
foreach ($cmp_path in $cmp_paths)
{
  if (Test-Path -Path $cmp_path -PathType Container)
  { # 文件夹则使其中的ps1均生效
    Get-ChildItem -Path $cmp_path -Filter *.ps1 | ForEach-Object {
      . $_.FullName
    }
  } elseif (Test-Path -Path $cmp_path)
  {
    . $cmp_path
  }
}
Remove-Variable -Name cmp_paths,cmp_path

# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:(too slow)
# Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
# Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

#region mamba initialize
# !! Contents within this block are managed by 'mamba shell init' !!
$Env:MAMBA_ROOT_PREFIX = "$Env:MINIFORGE"
$Env:MAMBA_EXE = "$Env:MINIFORGE\Library\bin\mamba.exe"
(& $Env:MAMBA_EXE 'shell' 'hook' -s 'powershell' -r $Env:MAMBA_ROOT_PREFIX) | Out-String | Invoke-Expression
#endregion
