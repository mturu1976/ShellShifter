

function Get-Cmd32 {
    $shell = if ([Environment]::Is64BitProcess) {
        [ShellShifterInfomation]::new(
            'cmd32',
            "$env:SystemRoot\SysWOW64\cmd.exe",
            ''
        )
    } else {
        [ShellShifterInfomation]::new(
            'cmd32',
            "$env:SystemRoot\System32\cmd.exe",
            ''
        )
    }
    $shell | Where-Object {$_ -and (Test-Path $_.Shell)}
}

function Get-Cmd64 {
    $shell = if ([Environment]::Is64BitProcess) {
        [ShellShifterInfomation]::new(
            'cmd64',
            "$env:SystemRoot\System32\cmd.exe",
            ''
        )
    } else {
        [ShellShifterInfomation]::new(
            'cmd64',
            "$env:SystemRoot\sysnative\cmd.exe",
            ''
        )
    }
    $shell | Where-Object {$_ -and (Test-Path $_.Shell)}
}

function Get-Cmd {
    Get-Cmd32
    Get-Cmd64
}

<#
.SYNOPSIS 32ビット版 cmd を実行します
.DESCRIPTION
32ビット版 cmd を実行します
#>
function Invoke-Cmd32 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True)]
        $_,
        [parameter(ValueFromRemainingArguments = $True, Position = 0)]
        [string[]]$Options = @()
    )
    begin {
        $this = $Cmd32
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

<#
.SYNOPSIS 64ビット版 cmd を実行します
.DESCRIPTION
64ビット版 cmd を実行します
#>
function Invoke-Cmd64 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$True)]
        $_,
        [parameter(ValueFromRemainingArguments = $True, Position = 0)]
        [string[]]$options = @()
    )
    begin {
        $this = $Cmd64
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

$Cmd32 = Get-Cmd32
$Cmd64 = Get-Cmd64

Set-Alias -Name cmd32 -Value Invoke-Cmd32
Set-Alias -Name cmd64 -Value Invoke-Cmd64
