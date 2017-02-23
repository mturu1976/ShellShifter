function Get-GitBash {
    $shells = @()
    # check uninstall registory 
    $reg = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Git_is*'
    Get-ChildItem -Path $reg | 
        Select-Object -First 1 |
        ForEach-Object {
            $root = $_.GetValue('InstallLocation')
            $shell = Join-Path $root '/usr/bin/bash.exe'
            $shells += @([ShellShifterInfomation]::new(
                'gitbash',
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
    $shells | Where-Object {$_ -and (Test-Path $_.Shell)}
}

<#
.SYNOPSIS GitBash の Mingw64 を実行します
.DESCRIPTION
GitBash の Mingw64 を実行します
#>
function Invoke-GitBash {
    param(
        [parameter(ValueFromRemainingArguments = $true, Position = 0)]
        [string[]]$Options = @()
    )
    $_ = Get-GitBash
    if ($_) {
        $Env:Path = (join-path (Split-Path $_.Shell) '/usr/bin') + ';'　+ $Env:Path
        # see /etc/profile
        $env:CHERE_INVOKING = 'true'
        $env:MSYS2_PATH_TYPE = ''
        $env:MSYSTEM = 'MINGW64'
        if ($Options -contains  '--no-login') {
            $Options = $Options | Where-Object {'--no-login', '--login', '-l' -notcontains $_}
            & ($_.Shell) $Options
        } else {
            & ($_.Shell) --login $Options
        }
    } else {
        Write-Error "GitBash Not Found"
    }
}

Set-Alias -Name gitbash -Value Invoke-GitBash
