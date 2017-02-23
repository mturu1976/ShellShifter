
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

<#
.SYNOPSIS Bash on Unbuntu on Windows を実行します
.DESCRIPTION
Bash on Unbuntu on Windows を実行します
#>
function Invoke-BashOnWindows {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True)]
        $_,
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

$Bow = Get-BashOnWindows

Set-Alias -Name bow -Value Invoke-BashOnWindows
