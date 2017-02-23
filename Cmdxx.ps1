

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
    if ($Cmd32) {
        & ($Cmd32).SHELL $args
    } else {
        Write-Error 'Cmd(x86) No Found'
    }
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
