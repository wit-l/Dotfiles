# CurrentUserCurrentHost (pwsh) — Scripts + mamba (keeps starship prompt)

$scriptsDir = Join-Path $PSScriptRoot 'Scripts'
if (Test-Path -LiteralPath $scriptsDir -PathType Container) {
    Get-ChildItem -LiteralPath $scriptsDir -Filter *.ps1 | ForEach-Object {
        . $_.FullName
    }
}

#region mamba initialize
# Must run at script scope (not inside a function): the hook installs
# `Invoke-Mamba` + alias `mamba`, which would otherwise disappear with local scope.
# ChangePs1 is forced off so mamba does not wrap/replace starship's prompt;
# no second starship init is needed after this.
if ($env:MINIFORGE) {
    $mambaExe = Join-Path $env:MINIFORGE 'Library\bin\mamba.exe'
    if (Test-Path -LiteralPath $mambaExe) {
        $env:MAMBA_ROOT_PREFIX = $env:MINIFORGE
        $env:MAMBA_EXE = $mambaExe
        $env:CONDA_CHANGEPS1 = 'false'
        $env:MAMBA_CHANGEPS1 = 'false'
        try {
            $mambaHook = & $env:MAMBA_EXE 'shell' 'hook' -s 'powershell' -r $env:MAMBA_ROOT_PREFIX | Out-String
            if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
                throw $mambaHook
            }
            # Hook text hardcodes ChangePs1=$True; force off so starship keeps prompt.
            $mambaHook = $mambaHook -replace 'ChangePs1\s*=\s*\$True', 'ChangePs1 = $false'
            Invoke-Expression $mambaHook
        } catch {
            Write-Warning "Mamba init failed: $($_.Exception.Message)"
        } finally {
            Remove-Variable -Name mambaHook, mambaExe -ErrorAction SilentlyContinue
        }
    } else {
        Write-Warning "mamba not found: $mambaExe"
    }
}
#endregion
