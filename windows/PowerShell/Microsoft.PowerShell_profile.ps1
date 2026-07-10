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
# $Env:HTTPS_PROXY = "http://127.0.0.1:7890"
# $Env:HTTP_PROXY = "http://127.0.0.1:7890"
$Env:EDITOR = "nvim"
$Env:KOMOREBI_CONFIG_HOME = "$Env:DOTDIR\windows\komorebi"

function Set-Proxy {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$ProxyUrl
    )

    $env:HTTP_PROXY = $ProxyUrl
    $env:HTTPS_PROXY = $ProxyUrl
    Write-Host "代理已设置为: $ProxyUrl"
}

function Clear-Proxy {
    Remove-Item Env:HTTP_PROXY -ErrorAction SilentlyContinue
    Remove-Item Env:HTTPS_PROXY -ErrorAction SilentlyContinue
    Write-Host "代理环境变量已清除。"
}
Set-Alias -Name "spr" -Value "Set-Proxy"
Set-Alias -Name "cpr" -Value "Clear-Proxy"
