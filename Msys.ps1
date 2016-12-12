function Get-Msys {

    # check environment
    if ($ENV:MSYS2_ROOT) {
        $root = $ENV:MSYS2_ROOT
        $bash = join-path $root '/usr/bin/bash.exe'
        @{
            Path = $root
            Shell = $bash
            Note = 'ENV:MSYS2_ROOT'
        }
    }

    # check registory of uninstall
    $reg = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
    Get-ChildItem -Path $reg |
        Where {$_.GetValue('Publisher') -eq 'The MSYS2 Developers'} |
        ForEach {
            $root = $_.GetValue('InstallLocation')
            $bash = Join-Path $root '/usr/bin/bash.exe'
            if (Test-Path $bash) {
                @{
                    Path = $root
                    Shell = $bash
                    Note = @((Join-Path $reg (Split-Path -Leaf $_)), 'InstallLocation') 
                }
            }
        }
}

function Invoke-MsysShell ([string[]]$Options) {
    $_ = Get-Msys | Select -First 1
    if ($_) {
        if (!(Test-Path $_.Shell)) {
            Write-Error 'Bash Not Found'
        }
        # see /etc/profile
        $env:CHERE_INVOKING = 'true'
        $env:MSYS2_PATH_TYPE = ''
        & ($_.Shell) --login $Options
    } else {
        Write-Error "$env:MSYSTEM Not Found"
    }
}

<#
.SYNOPSIS Msys2 の bash を実行します
.DESCRIPTION
環境変数 MSYS2_ROOT もしくはインストール情報を元にし
Msys2 の bash を実行します
.INPUTS No Care
.OUTPUTS No Care
.EXAMPLE msys -c './BashScript Foo Bar Baz'
.EXAMPLE msys
.NOTES
実行判定順序
1. MSYS2_ROOT
2. レジストリ内にあるインストール情報の順番
.LINK Nothing
#>
function Invoke-Msys {
    param(
        [parameter(ValueFromRemainingArguments = $true, Position = 0)]
        [string[]]$Options = @()
    )
    $env:MSYSTEM = 'MSYS'
    Invoke-MsysShell $Options
}

<#
.SYNOPSIS Msys2 の Mingw32 を実行します
.DESCRIPTION
環境変数 MSYS2_ROOT もしくはインストール情報を元にし
Msys2 の Mingw32 を実行します
see Invoke-Msys
#>
function Invoke-Mingw32 {
    param(
        [parameter(ValueFromRemainingArguments = $true, Position = 0)]
        [string[]]$Options = @()
    )
    $env:MSYSTEM = 'MINGW32'
    Invoke-MsysShell $Options
}

<#
.SYNOPSIS Msys2 の Mingw64 を実行します
.DESCRIPTION
環境変数 MSYS2_ROOT もしくはインストール情報を元にし
Msys2 の Mingw64 を実行します
see Invoke-Msys
#>
function Invoke-Mingw64 {
    param(
        [parameter(ValueFromRemainingArguments = $true, Position = 0)]
        [string[]]$Options = @()
    )
    $env:MSYSTEM = 'MINGW64'
    Invoke-MsysShell $Options
}

function msys {
    Invoke-Msys $args
}

function mingw32 {
    Invoke-Mingw32 $args
}

function mingw64 {
    Invoke-Mingw64 $args
}

Set-Alias -Name msys -Value Invoke-Msys
Set-Alias -Name mingw64 -Value Invoke-Mingw64
Set-Alias -Name mingw32 -Value Invoke-Mingw32 
