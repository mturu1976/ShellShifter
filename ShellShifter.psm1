
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

function Invoke-ShellShifter {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Postion = 0)]
        [ShellShifter]$Info,
        [Parameter(Mandatory = $True, Postion = 1)]
        [string[]]$Options
    )
    begin {
        $this = $Info
        if (!$this) {
            Write-Error 'Command No Found'
            return
        }
    }
    process {
        $stdins += $_
    }
    end {
        if ($stdins) {
            $stdins | & $this.Shell $Options
        } else {
            & $this.Shell $Options
        }
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

