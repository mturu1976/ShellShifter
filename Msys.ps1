function Get-Msys {

    $shells = @()

    # check environment
    if ($ENV:MSYS2_ROOT) {
        $root = $ENV:MSYS2_ROOT
        $shell = join-path $root '/usr/bin/bash.exe'
        $shells += @([ShellShifterInfomation]::new(
            'msys',
            $shell,
            'ENV:MSYS2_ROOT'
        ))
    }

    # check registory of uninstall
    $reg = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
    Get-ChildItem -Path $reg |
        Where-Object {$_.GetValue('Publisher') -eq 'The MSYS2 Developers'} |
        Select-Object -First 1 |
        ForEach-Object {
            $root = $_.GetValue('InstallLocation')
            $shell = Join-Path $root '/usr/bin/bash.exe'
            $shells += @([ShellShifterInfomation]::new(
                'msys',
                $shell,
                (Join-Path $reg (Split-Path -Leaf $_))
            ))
            # if (Test-Path $bash) {
            #     @{
            #         Path = $root
            #         Shell = $bash
            #         Note = @((Join-Path $reg (Split-Path -Leaf $_)), 'InstallLocation') 
            #     }
            # }
        }

    $shells | Where-Object {$_ -and (Test-Path $_.Shell)} |
        ForEach-Object {
            $_
            [ShellShifterInfomation]::new(
                'mingw32',
                $_.Shell,
                $_.Note
            )
            [ShellShifterInfomation]::new(
                'mingw64',
                $_.Shell,
                $_.Note
            )
        }
}

function Invoke-MsysShell ([string[]]$Options) {
    $_ = Get-Msys | Where-Object {$_.Command -eq 'msys'}
    if ($_) {
        $Env:Path = (join-path (Split-Path $_.Shell) '/usr/bin') + ';'　+ $Env:Path       
        # see /etc/profile
        $env:CHERE_INVOKING = 'true'
        $env:MSYS2_PATH_TYPE = ''
        if ($Options -contains  '--no-login') {
            $Options = $Options | Where-Object {'--no-login', '--login', '-l' -notcontains $_}
            & ($_.Shell) $Options
        } else {
            & ($_.Shell) --login $Options
        }
    } else {
        Write-Error "Msys Not Found"
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

Set-Alias -Name msys -Value Invoke-Msys
Set-Alias -Name mingw64 -Value Invoke-Mingw64
Set-Alias -Name mingw32 -Value Invoke-Mingw32 
