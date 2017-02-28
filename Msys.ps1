using namespace System
function Get-Msys {

    $shells = @()

    # check environment
    if ($ENV:MSYS2_ROOT) {
        $root = $ENV:MSYS2_ROOT
        $shell = join-path $root '/usr/bin/bash.exe'
        $shells += @([ShellShifterInfomation]::new(
            'msys',
            $shell,
            '$ENV:MSYS2_ROOT'
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
        [switch]$NoLogin,
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
        $Options = if ($NoLogin) {
            $Options
        } else {
            '--login'
            $Options
        }

        # $prev = $ENV:Path
        # $ENV:Path = (Split-Path $this.Shell) + ';'　+ $ENV:Path

        # see /etc/profile
        $ENV:MSYSTEM = 'MSYS'
        $ENV:CHERE_INVOKING = 'true'
        $ENV:MSYS2_PATH_TYPE = 'inherit' # strict / inherit

        if ($stdins) {
            $stdins | & $this.Shell $Options
        } else {
            & $this.Shell $Options
        }

        # $ENV:Path = $prev
    }
}

#.ExternalHelp ShellShifter.psm1-help.xml
function Invoke-Mingw32 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True)]
        [string]$Stdin,
        [switch]$NoLogin,
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
        $Options = if ($NoLogin) {
            $Options
        } else {
            '--login'
            $Options
        }

        # $prev = $ENV:Path
        # $ENV:Path = (Split-Path $this.Shell) + ';'　+ $ENV:Path

        # see /etc/profile
        $ENV:MSYSTEM = 'MINGW32'
        $ENV:CHERE_INVOKING = 'true'
        $ENV:MSYS2_PATH_TYPE = 'inherit'　# strict / inherit

        if ($stdins) {
            $stdins | & $this.Shell $Options
        } else {
            & $this.Shell $Options
        }

        # $ENV:Path = $prev
    }
}

#.ExternalHelp ShellShifter.psm1-help.xml
function Invoke-Mingw64 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True)]
        [string]$Stdin,
        [switch]$NoLogin,
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
        $Options = if ($NoLogin) {
            $Options
        } else {
            '--login'
            $Options
        }

        # $prev = $ENV:Path
        # $ENV:Path = (Split-Path $this.Shell) + ';'　+ $ENV:Path

        # see /etc/profile
        $ENV:MSYSTEM = 'MINGW64'
        $ENV:CHERE_INVOKING = 'true'
        $ENV:MSYS2_PATH_TYPE = 'inherit'　# strict / inherit

        if ($stdins) {
            $stdins | & $this.Shell $Options
        } else {
            & $this.Shell $Options
        }

        # $ENV:Path = $prev
    }
}

Set-Alias -Name msys -Value Invoke-Msys
Set-Alias -Name mingw64 -Value Invoke-Mingw64
Set-Alias -Name mingw32 -Value Invoke-Mingw32 
