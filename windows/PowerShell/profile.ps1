# CurrentUserAllHosts — encoding, prompt, node/zoxide, PSReadLine

$utf8 = [System.Text.UTF8Encoding]::new()
[Console]::InputEncoding = $utf8
[Console]::OutputEncoding = $utf8
$PSStyle.FileInfo.Directory = "`e[34;1m"

function Invoke-ProfileHook {
    param(
        [Parameter(Mandatory)]
        [string]$Name,
        [Parameter(Mandatory)]
        [scriptblock]$Script
    )
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        return
    }
    try {
        & $Script
    } catch {
        Write-Warning "Profile hook failed ($Name): $($_.Exception.Message)"
    }
}

# Skip fancy prompt in non-VT / dumb terminals (CI, redirected hosts, etc.)
if ($env:TERM -ne 'dumb' -and $Host.UI.SupportsVirtualTerminal) {
    Invoke-ProfileHook starship {
        starship init powershell | Out-String | Invoke-Expression
    }
}

Invoke-ProfileHook fnm {
    fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
}

Invoke-ProfileHook zoxide {
    zoxide init powershell | Out-String | Invoke-Expression
}

if (Get-Module -ListAvailable PSReadLine) {
    try {
        $psrl = @{
            HistorySearchCursorMovesToEnd = $true
            EditMode                      = 'Emacs'
            BellStyle                     = 'None'
        }
        if ($Host.UI.SupportsVirtualTerminal -and $env:TERM -ne 'dumb') {
            $psrl.PredictionSource = 'History'
            $psrl.PredictionViewStyle = 'InlineView'
        } else {
            $psrl.PredictionSource = 'None'
        }
        Set-PSReadLineOption @psrl
        Set-PSReadLineKeyHandler -Key 'Tab' -Function MenuComplete
    } catch {
        Write-Warning "PSReadLine setup skipped: $($_.Exception.Message)"
    }
}
