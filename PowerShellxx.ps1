<#
.SYNOPSIS 32ビット版 powershell を実行します
.DESCRIPTION
32ビット版 powershell を実行します
#>
function Invoke-PowerShell32 {
    & ($PowerShell32).SHELL $args
}

<#
.SYNOPSIS 64ビット版 powershell を実行します
.DESCRIPTION
64ビット版 powershell を実行します
#>
function Invoke-PowerShell64 {
    if ($PowerShell64) {
        & ($PowerShell64).SHELL $args
    } else {
        Write-Error 'PowerShell64 No Found'
    }
}

function Get-PowerShell32 {
    if ([Environment]::Is64BitProcess) {
        @{SHELL = "$env:SystemRoot\SysWOW64\WindowsPowerShell\v1.0\powershell.exe"}
    } else {
        @{SHELL = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"}
    }
}

function Get-PowerShell64 {
    if ([Environment]::Is64BitProcess) {
        @{SHELL = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"}
    } else {
        # for windows 32bit
        "$env:SystemRoot\sysnative\WindowsPowerShell\v1.0\powershell.exe" |
            Where {Test-Path $_} | 
            ForEach { @{SHELL = $_} }
    }
}

$PowerShell32 = Get-PowerShell32
$PowerShell64 = Get-PowerShell64

Set-Alias -Name posh32 -Value Invoke-PowerShell32
Set-Alias -Name posh64 -Value Invoke-PowerShell64
