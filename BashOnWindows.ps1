﻿
function Get-BashOnWindows {
    if ([Environment]::Is64BitProcess) {
        "$env:SystemRoot\System32\bash.exe" |
            Where {Test-Path $_} |
            ForEach {@{SHELL = $_}}
    } else {
        "$env:SystemRoot\sysnative\bash.exe" |
            Where {Test-Path $_} |
            ForEach {@{SHELL = $_}}
    }
}

<#
.SYNOPSIS Bash on Unbuntu on Windows を実行します
.DESCRIPTION
Bash on Unbuntu on Windows を実行します
#>
function Invoke-BashOnWindows {
    if ($Bow) {
        & ($Bow).SHELL $args
    } else {
        Write-Error 'Bash On Windows No Found'
    }
}

$Bow = Get-BashOnWindows

Set-Alias -Name bow -Value Invoke-BashOnWindows
