﻿function Get-Msys {

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
        }

    # only exists
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

#.ExternalHelp ShellShifter.psm1-help.xml
function Invoke-Msys {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True)]
        [string]$Stdin,
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
        $stdins += $Stdin
    }
    end {
        $env:Path = (Split-Path $this.Shell) + ';'　+ $Env:Path
        # see /etc/profile
        $ENV:MSYSTEM = 'MSYS'
        $env:CHERE_INVOKING = 'true'
        $env:MSYS2_PATH_TYPE = ''

        if ($stdins) {
            $stdins | & $this.Shell $Options
        } else {
            & $this.Shell $Options
        }
    }
}

#.ExternalHelp ShellShifter.psm1-help.xml
function Invoke-Mingw32 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True)]
        [string]$Stdin,
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
        $stdins += $Stdin
    }
    end {
        $env:Path = (Split-Path $this.Shell) + ';'　+ $Env:Path
        # see /etc/profile
        $ENV:MSYSTEM = 'MINGW32'
        $env:CHERE_INVOKING = 'true'
        $env:MSYS2_PATH_TYPE = ''

        if ($stdins) {
            $stdins | & $this.Shell $Options
        } else {
            & $this.Shell $Options
        }
    }
}

#.ExternalHelp ShellShifter.psm1-help.xml
function Invoke-Mingw64 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True)]
        [string]$Stdin,
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
        $stdins += $Stdin
    }
    end {
        $env:Path = (Split-Path $this.Shell) + ';'　+ $Env:Path
        # see /etc/profile
        $ENV:MSYSTEM = 'MINGW64'
        $env:CHERE_INVOKING = 'true'
        $env:MSYS2_PATH_TYPE = ''

        if ($stdins) {
            $stdins | & $this.Shell $Options
        } else {
            & $this.Shell $Options
        }
    }
}

Set-Alias -Name msys -Value Invoke-Msys
Set-Alias -Name mingw64 -Value Invoke-Mingw64
Set-Alias -Name mingw32 -Value Invoke-Mingw32 
