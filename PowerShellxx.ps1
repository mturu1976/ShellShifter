using namespace System.Collections.Generic

<#
.SYNOPSIS 32ビット版 powershell を実行します
.DESCRIPTION
32ビット版 powershell を実行します
#>
function Invoke-PowerShell32 {
    & ($PowerShell32).Shell $args
}

<#
.SYNOPSIS 64ビット版 powershell を実行します
.DESCRIPTION
64ビット版 powershell を実行します
#>
function Invoke-PowerShell64 {
    if ($PowerShell64) {
        & ($PowerShell64).Shell $args
    } else {
        Write-Error 'PowerShell64 No Found'
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

