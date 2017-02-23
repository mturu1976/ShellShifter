
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
    if ($Bow) {
        & ($Bow).Shell $args
    } else {
        Write-Error 'Bash On Windows No Found'
    }
}

$Bow = Get-BashOnWindows

Set-Alias -Name bow -Value Invoke-BashOnWindows
