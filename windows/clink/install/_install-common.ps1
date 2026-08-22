# Shared helpers for clink profile install scripts.

param(
    [string]$Proxy = 'http://127.0.0.1:7890',
    [switch]$NoProxy
)

$script:ClinkProfileDir = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$script:ClinkSoftwareRoot = if ($env:CLINK_SOFTWARE_HOME) { $env:CLINK_SOFTWARE_HOME } else { 'C:\Software\clink' }
$script:InstallProxy = if ($NoProxy) { $null } else { $Proxy }

function Use-InstallProxy {
    if (-not $script:InstallProxy) { return }
    $env:HTTP_PROXY = $script:InstallProxy
    $env:HTTPS_PROXY = $script:InstallProxy
    $env:ALL_PROXY = $script:InstallProxy
    Write-Host "Using proxy: $($script:InstallProxy)"
}

function Invoke-Git {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    Use-InstallProxy
    if ($script:InstallProxy) {
        & git -c "http.proxy=$($script:InstallProxy)" -c "https.proxy=$($script:InstallProxy)" @Args
    } else {
        & git @Args
    }
    if ($LASTEXITCODE -ne 0) { throw "git $($Args -join ' ') failed (exit $LASTEXITCODE)" }
}

function Ensure-GitRepo {
    param(
        [string]$Repo,
        [string]$CloneUrl
    )
    if (Test-Path -LiteralPath (Join-Path $Repo '.git') -PathType Container) {
        $head = Invoke-Git -Args @('-C', $Repo, 'rev-parse', 'HEAD') 2>$null
        if (-not $head) {
            Write-Host "Removing incomplete repo at $Repo ..."
            Remove-Item -LiteralPath $Repo -Recurse -Force
        } else {
            Write-Host "Updating $Repo ..."
            Invoke-Git -Args @('-C', $Repo, 'pull', '--ff-only')
            return
        }
    }
    $parent = Split-Path -Parent $Repo
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    Write-Host "Cloning $CloneUrl into $Repo ..."
    Invoke-Git -Args @('clone', $CloneUrl, $Repo)
}

function New-ProfileSymlink {
    param(
        [string]$ProfileDir,
        [string]$Name,
        [string]$Target
    )
    $link = Join-Path $ProfileDir $Name
    if (-not (Test-Path -LiteralPath $Target)) {
        throw "Missing upstream file: $Target"
    }
    $targetPath = (Resolve-Path -LiteralPath $Target).Path
    if (Test-Path -LiteralPath $link) {
        Remove-Item -LiteralPath $link -Force
    }
    try {
        New-Item -ItemType SymbolicLink -Path $link -Target $targetPath -ErrorAction Stop | Out-Null
        Write-Host "Symlinked $Name -> $targetPath"
    } catch {
        throw @"
Failed to create symlink for $Name.
Enable Windows Developer Mode, or run PowerShell as Administrator, then retry.
$($_.Exception.Message)
"@
    }
}
