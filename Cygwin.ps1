function Get-Cygwin {

    # check environment
    if ($ENV:CYGWIN_ROOT) {
        $root = $ENV:CYGWIN_ROOT
        $bash = join-path $root '/bin/bash.exe'
        @{
            Path = $root
            Shell = $bash 
            Note = 'ENV:CYGWIN_ROOT'
        }
    }

    # check last setup registory 
    # 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Cygwin\setup'
    $reg = 'HKLM:SOFTWARE\Cygwin\setup'
    $root = Get-ItemPropertyValue -Path $reg -Name 'rootdir' -ErrorAction SilentlyContinue
    if ($root) {
        $bash = Join-Path $root '/bin/bash.exe'
        if (Test-Path $bash) {
            @{
                Path = $root
                Shell = $bash
                Note = @($reg, 'rootdir')
            }
        }
    }

    if (![Environment]::Is64BitProcess) {
        # check last setup registory 
        $key = [Microsoft.Win32.RegistryKey]::OpenBaseKey(
            [Microsoft.Win32.RegistryHive]::LocalMachine,
            [Microsoft.Win32.RegistryView]::Registry64
            )
        $prop = $key.OpenSubKey("SOFTWARE\Cygwin\setup")
        $root = $prop.GetValue("rootdir")
        if ($root) {
            $bash = Join-Path $root '/bin/bash.exe'
            if (Test-Path $bash) {
                @{
                    Path = $root
                    Shell = $bash
                    Note = @($reg, 'rootdir')
                }
            }
        }
    }
}

<#
.SYNOPSIS Cygwin の bash を実行します
.DESCRIPTION
環境変数 CYGWIN_ROOT もしくはインストール情報を元にし
Cygwin の bash を実行します
.INPUTS No Care
.OUTPUTS No Care
.EXAMPLE cygwin -c './BashScript Foo Bar Baz'
.EXAMPLE cygwin
.NOTES
実行判定順位
1. CYGWIN_ROOT
2. レジストリ内にあるインストール情報
.LINK Nothing
#>
function Invoke-Cygwin {
    param(
        [parameter(ValueFromRemainingArguments = $true, Position = 0)]
        [string[]]$Options = @()
    )
    $_ = Get-Cygwin | Select-Object -First 1
    if ($_) {
        if (!(Test-Path $_.Shell)) {
            Write-Error 'Bash Not Found'
        }
        if (!$ENV:LANG) {$ENV:LANG = 'ja_JP.UTF-8'}
        if (!$ENV:CYGWIN) {$ENV:CYGWIN = 'nodosfilewarning'}
        if (!$ENV:DISPLAY) {$ENV:DISPLAY = ':0.0'}
        $env:CHERE_INVOKING = 'true'
        if ($Options -contains '--no-login') {
            $Options = $Options | Where-Object {'--no-login', '--login', '-l' -notcontains $_}
            & ($_.Shell) $Options
        } else {
            & ($_.Shell) --login $Options
        }
    } else {
        Write-Error "Cygwin Not Found"
    }
}

Set-Alias -Name cygwin -Value Invoke-Cygwin
