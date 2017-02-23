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

function Invoke-MsysWrap {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True)]
        $_,
        [parameter(ValueFromRemainingArguments = $True, Position = 0)]
        [string[]]$Options = @()
    )
    begin {
        $this = Get-Msys | Where-Object {$_.Command -eq 'msys'}
        if (!$this) {
            Write-Error 'Command No Found'
            return
        }
    }
    process {
        $stdins += $_
    }
    end {
        # see /etc/profile
        # $ENV:MSYSTEM = 'MSYS'
        $env:CHERE_INVOKING = 'true'
        $env:MSYS2_PATH_TYPE = ''

        $Options = if ($Options -contains '--no-login') {
            $Options | Where-Object {'--no-login', '--login', '-l' -notcontains $_}
        } else {
            '--login'
            $Options
        }

        $env:Path = (Split-Path $this.Shell) + ';'　+ $Env:Path       
        if ($stdins) {
            $stdins | & $this.Shell $Options
        } else {
            & $this.Shell $Options
        }
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
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True)]
        $_,
        [parameter(ValueFromRemainingArguments = $True, Position = 0)]
        [string[]]$Options = @()
    )
    process {
        $stdins += $_
    }
    end {
        $ENV:MSYSTEM = 'MSYS'
        if ($stdins) {
            $stdins | Invoke-MsysWrap $Options
        } else {
            Invoke-MsysWrap $Options
        }
    }
}

<#
.SYNOPSIS Msys2 の Mingw32 を実行します
.DESCRIPTION
環境変数 MSYS2_ROOT もしくはインストール情報を元にし
Msys2 の Mingw32 を実行します
see Invoke-Msys
#>
function Invoke-Mingw32 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True)]
        $_,
        [parameter(ValueFromRemainingArguments = $True, Position = 0)]
        [string[]]$Options = @()
    )
    process {
        $stdins += $_
    }
    end {
        $ENV:MSYSTEM = 'MINGW32'
        if ($stdins) {
            $stdins | Invoke-MsysWrap $Options
        } else {
            Invoke-MsysWrap $Options
        }
    }
}

<#
.SYNOPSIS Msys2 の Mingw64 を実行します
.DESCRIPTION
環境変数 MSYS2_ROOT もしくはインストール情報を元にし
Msys2 の Mingw64 を実行します
see Invoke-Msys
#>
function Invoke-Mingw64 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True)]
        $_,
        [parameter(ValueFromRemainingArguments = $True, Position = 0)]
        [string[]]$Options = @()
    )
    process {
        $stdins += $_
    }
    end {
        $ENV:MSYSTEM = 'MINGW64'
        if ($stdins) {
            $stdins | Invoke-MsysWrap $Options
        } else {
            Invoke-MsysWrap $Options
        }
    }
}

Set-Alias -Name msys -Value Invoke-Msys
Set-Alias -Name mingw64 -Value Invoke-Mingw64
Set-Alias -Name mingw32 -Value Invoke-Mingw32 
