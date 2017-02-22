
# Get-ChildItem $PSScriptRoot\*.ps1 | ForEach-Object { . $_.FullName }

class ShellShifterInfomation {
    [string]$Command
    [string]$Shell
    [string]$Path
    [string]$Note

    ShellShifterInfomation() {
    }

    ShellShifterInfomation([string]$Command, [string]$Shell) {
        $this.Command = $Command
        $this.Shell = $Shell
    }
}

. "$PSScriptRoot/PowerShellxx.ps1"
. "$PSScriptRoot/Cmdxx.ps1"
. "$PSScriptRoot/BashOnWindows.ps1"

. "$PSScriptRoot/GitBash.ps1"
. "$PSScriptRoot/Msys.ps1"
. "$PSScriptRoot/Cygwin.ps1"

function Get-ShellShifter {

    ((Get-PowerShell) +
        (Get-Cmd) +
        (Get-BashOnWindows)) |
        Format-Table |
        Out-String |
        write-host
    
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

