using namespace System.Collections.Generic

#.ExternalHelp ShellShifter.psm1-help.xml
function Invoke-PowerShell32 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True)]
        $Stdin,
        [parameter(ValueFromRemainingArguments = $True, Position = 0)]
        [string[]]$Options = @()
    )
    begin {
        $this = $PowerShell32
        if (!$this) {
            Write-Error 'Command No Found'
            return
        }
    }
    process {
        $stdins += $Stdin
    }
    end {
        if ($stdins) {
            $stdins | & $this.Shell $Options
        } else {
            & $this.Shell $Options
        }
    }
}

#.ExternalHelp ShellShifter.psm1-help.xml
function Invoke-PowerShell64 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True)]
        $Stdin,
        [parameter(ValueFromRemainingArguments = $True, Position = 0)]
        [string[]]$Options = @()
    )
    begin {
        $this = $PowerShell64
        if (!$this) {
            Write-Error 'Command No Found'
            return
        }
    }
    process {
        $stdins += $Stdin
    }
    end {
        if ($stdins) {
            $stdins | & $this.Shell $Options
        } else {
            & $this.Shell $Options
        }
    }
}

function Get-PowerShell32() {
    $shell = if ([Environment]::Is64BitProcess) {
        [ShellShifterInfomation]::new(
            'posh32',
            "$env:SystemRoot\SysWOW64\WindowsPowerShell\v1.0\powershell.exe",
            ''
        )
    } else {
        [ShellShifterInfomation]::new(
            'posh32',
            "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe",
            ''
        )
    }   
    $shell | Where-Object {$_ -and (Test-Path $_.Shell)}
}

function Get-PowerShell64 {
    $shell = if ([Environment]::Is64BitProcess) {
        [ShellShifterInfomation]::new(
            'posh64',
            "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe",
            ''
        )
    } else {
        [ShellShifterInfomation]::new(
            'posh64',
            "$env:SystemRoot\sysnative\WindowsPowerShell\v1.0\powershell.exe",
            ''
        )
    }   
    $shell | Where-Object {$_ -and (Test-Path $_.Shell)}
}

function Get-PowerShell {
    Get-PowerShell32
    Get-PowerShell64
}

$PowerShell32 = Get-PowerShell32
$PowerShell64 = Get-PowerShell64

Set-Alias -Name posh32 -Value Invoke-PowerShell32
Set-Alias -Name posh64 -Value Invoke-PowerShell64

