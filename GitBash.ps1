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
        }
    $shells | Where-Object {$_ -and (Test-Path $_.Shell)}
}

#.ExternalHelp ShellShifter.psm1-help.xml
function Invoke-GitBash {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True)]
        [string]$Stdin,
        [switch]$NoLogin,
        [parameter(ValueFromRemainingArguments = $True, Position = 0)]
        [string[]]$Options = @()
    )
    begin {
        $this = Get-GitBash
        if (!$this) {
            Write-Error 'Command Not Found'
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

        $ENV:Path = (Split-Path $this.Shell) + ';'　+ $ENV:Path       
        # see /etc/profile
        $ENV:CHERE_INVOKING = 'true'
        $ENV:MSYS2_PATH_TYPE = ''
        $ENV:MSYSTEM = 'MINGW64'

        if ($stdins) {
            $stdins | & $this.Shell $Options
        } else {
            & $this.Shell $Options
        }
    }
}

Set-Alias -Name gitbash -Value Invoke-GitBash
