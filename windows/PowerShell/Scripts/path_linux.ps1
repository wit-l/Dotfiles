# Toggle $env:GIT\usr\bin on PATH.
# Aliases: elt / dlt

function Get-GitUsrBin {
    $git = $env:GIT
    if ([string]::IsNullOrWhiteSpace($git)) {
        return $null
    }
    return (Join-Path $git.TrimEnd('\', '/') 'usr\bin')
}

function EnableLinuxTools {
    $usrBin = Get-GitUsrBin
    if (-not $usrBin) {
        Write-Host 'GIT environment variable is not set.'
        return
    }
    $parts = @($env:PATH -split ';' | Where-Object { $_ })
    $exists = $parts | Where-Object { $_.TrimEnd('\') -ieq $usrBin.TrimEnd('\') }
    if (-not $exists) {
        $parts += $usrBin
        $env:PATH = $parts -join ';'
    }
}

function DisableLinuxTools {
    $usrBin = Get-GitUsrBin
    if (-not $usrBin) {
        return
    }
    $target = $usrBin.TrimEnd('\')
    $parts = @($env:PATH -split ';' | Where-Object {
            $_ -and ($_.TrimEnd('\') -ine $target)
        })
    $env:PATH = $parts -join ';'
}

Set-Alias -Name "elt" -Value "EnableLinuxTools" -Force
Set-Alias -Name "dlt" -Value "DisableLinuxTools" -Force
