
function Get-Cmd32 {
    if ([Environment]::Is64BitProcess) {
        @{SHELL = "$env:SystemRoot\SysWOW64\cmd.exe"}
    } else {
        @{SHELL = "$env:SystemRoot\System32\cmd.exe"}
    }
}

function Get-Cmd64 {
    if ([Environment]::Is64BitProcess) {
        @{SHELL = "$env:SystemRoot\System32\cmd.exe"}
    } else {
        # for windows 32bit
        "$env:SystemRoot\sysnative\cmd.exe" |
            Where {Test-Path $_} |
            ForEach {@{SHELL = $_}}
    }
}

<#
.SYNOPSIS 32ビット版 cmd を実行します
.DESCRIPTION
32ビット版 cmd を実行します
#>
function Invoke-Cmd32 {
    & ($Cmd32).SHELL $args
}

<#
.SYNOPSIS 64ビット版 cmd を実行します
.DESCRIPTION
64ビット版 cmd を実行します
#>
function Invoke-Cmd64 {
    if ($Cmd64) {
        & ($Cmd64).SHELL $args
    } else {
        Write-Error 'Cmd(x64) No Found'
    }
}

$Cmd32 = Get-Cmd32
$Cmd64 = Get-Cmd64

Set-Alias -Name cmd32 -Value Invoke-Cmd32
Set-Alias -Name cmd64 -Value Invoke-Cmd64
