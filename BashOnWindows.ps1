
function Get-BashOnWindows {
    $shell = if ([Environment]::Is64BitProcess) {
        [ShellShifterInfomation]::new(
            'bow',
            "$env:SystemRoot\System32\bash.exe",
            ''
        )
    } else {
        [ShellShifterInfomation]::new(
            'bow',
            "$env:SystemRoot\sysnative\bash.exe",
            ''
        )
    }
    @($shell | Where-Object {Test-Path $_.Shell})
}

#.ExternalHelp ShellShifter.psm1-help.xml
function Invoke-BashOnWindows {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True)]
        [string]$Stdin,
        [parameter(ValueFromRemainingArguments = $True, Position = 0)]
        [string[]]$Options = @()
    )
    begin {
        $this = $Bow
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

$Bow = Get-BashOnWindows

Set-Alias -Name bow -Value Invoke-BashOnWindows
