﻿function Get-Cygwin {

    $shells = @()

    # check environment
    if ($ENV:CYGWIN_ROOT) {
        $root = $ENV:CYGWIN_ROOT
        $shell = join-path $root '/bin/bash.exe'
        $shells += @([ShellShifterInfomation]::new(
            'cygwin',
            $shell,
            ''
        ))
    }

    # check last setup registory 
    # 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Cygwin\setup'
    $key = [Microsoft.Win32.RegistryKey]::OpenBaseKey(
        [Microsoft.Win32.RegistryHive]::LocalMachine,
        [Microsoft.Win32.RegistryView]::Registry64
        )
    if ($key) {
        $prop = $key.OpenSubKey("SOFTWARE\Cygwin\setup")
        $root = $prop.GetValue("rootdir")
        if ($root) {
            $shell = Join-Path $root '/bin/bash.exe'
            $shells += @([ShellShifterInfomation]::new(
                'cygwin',
                $shell,
                $reg
            ))
        }
    }

    $reg = 'HKLM:SOFTWARE\Cygwin\setup'
    Get-ItemPropertyValue -Path $reg -Name 'rootdir' -ErrorAction SilentlyContinue |
        ForEach-Object {
            $shell = Join-Path $_ '/bin/bash.exe'
            $shells += @([ShellShifterInfomation]::new(
                'cygwin',
                $shell,
                $reg
            ))
        }

    $shells | Where-Object {$_ -and (Test-Path $_.Shell)} | Select-Object -First 1
}

#.ExternalHelp ShellShifter.psm1-help.xml
function Invoke-Cygwin {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True)]
        [string]$Stdin,
        [parameter(ValueFromRemainingArguments = $True, Position = 0)]
        [string[]]$Options = @()
    )
    begin {
        $this = Get-Cygwin
        if (!$this) {
            Write-Error 'Command No Found'
            return
        }
    }
    process {
        $stdins += $Stdin
    }
    end {
        $ENV:CHERE_INVOKING = 'true'
        # if (!$ENV:LANG) {$ENV:LANG = 'ja_JP.UTF-8'}
        # if (!$ENV:CYGWIN) {$ENV:CYGWIN = 'nodosfilewarning'}
        # if (!$ENV:DISPLAY) {$ENV:DISPLAY = ':0.0'}

        if ($stdins) {
            $stdins | & $this.Shell $Options
        } else {
            & $this.Shell $Options
        }
    }    
}

Set-Alias -Name cygwin -Value Invoke-Cygwin
