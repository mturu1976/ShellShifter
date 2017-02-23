
# Get-ChildItem $PSScriptRoot\*.ps1 | ForEach-Object { . $_.FullName }

class ShellShifterInfomation {
    [string]$Command
    [string]$Shell
    [string]$Note

    ShellShifterInfomation() {
    }

    ShellShifterInfomation([string]$Command, [string]$Shell, [string]$Note) {
        $this.Command = $Command
        $this.Shell = $Shell
        $this.Note = $Note
    }
}

. "$PSScriptRoot/PowerShellxx.ps1"
. "$PSScriptRoot/Cmdxx.ps1"
. "$PSScriptRoot/BashOnWindows.ps1"

. "$PSScriptRoot/GitBash.ps1"
. "$PSScriptRoot/Msys.ps1"
. "$PSScriptRoot/Cygwin.ps1"

function Get-ShellShifter {
    Get-PowerShell
    Get-Cmd
    Get-BashOnWindows
    Get-Msys
    Get-GitBash
    Get-Cygwin
    # Format-Table | Out-String | write-host
}

