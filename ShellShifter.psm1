
# Get-ChildItem $PSScriptRoot\*.ps1 | ForEach-Object { . $_.FullName }

. "$PSScriptRoot/PowerShellxx.ps1"
. "$PSScriptRoot/Cmdxx.ps1"
. "$PSScriptRoot/BashOnWindows.ps1"

. "$PSScriptRoot/GitBash.ps1"
. "$PSScriptRoot/Msys.ps1"
. "$PSScriptRoot/Cygwin.ps1"

function Get-ShellShifter {
    if (Get-PowerShell32) {
        write-host 'posh32'
    }
    if (Get-PowerShell64) {
        write-host 'posh64'
    }
    if (Get-Cmd32) {
        write-host 'cmd32'
    }
    if (Get-Cmd64) {
        write-host 'cmd64'
    }
    if (Get-BashOnWindows) {
        write-host 'bow'
    }

    if (Get-Msys) {
        write-host 'msys'
        write-host 'mingw32'
        write-host 'mingw64'
    }

    if (Get-GitBash) {
        write-host 'gitbash'
    }

    if (Get-Cygwin) {
        write-host 'cygwin'
    }
}

