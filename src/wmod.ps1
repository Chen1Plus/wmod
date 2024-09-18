. $PSScriptRoot\lib\env.ps1
. $PSScriptRoot\lib\log.ps1

# Utilities
function Get-ModulePath {
    param (
        [string]$moduleName,
        [string]$version
    )

    if ((-not (Test-Path "$MODULEPATH\$moduleName")) -or (-not (Test-Path "$MODULEPATH\$moduleName\$version.ps1"))) {
        error "The module file is not found at $MODULEPATH\$moduleName\$version.ps1"
    }
    return (Get-Item "$MODULEPATH\$moduleName").GetFiles("$version.ps1").FullName
}

function Unload-ByPath {
    param (
        [string]$modulePath
    )
    
    if ((-not $env:WmodLOADED) -or (-not $env:WmodLOADED.Contains($modulePath))) {
        error 'The module is not loaded.'
    }
    elseif (-not (Test-Path $modulePath)) {
        error "The module file is not found at $modulePath"
    }
    else {
        . $modulePath

        # modify $env:PATH
        $env:PATH = $env:PATH.Replace($Path, '')

        # remove environment variables
        if ($EnvVars) {
            $EnvVars.Keys | ForEach-Object {
                Remove-Item -Path "Env:\$_"
            }
        }

        $env:WmodLOADED = $env:WmodLOADED | Where-Object { $_ -ne $modulePath }

        Write-Host "The module unloaded successfully."
    }
}


switch ($Args[0]) {
    'avail' {
        Get-ChildItem $MODULEPATH -Directory | ForEach-Object {
            $name = $_.Name
            Get-ChildItem $_.FullName -Filter '*.ps1' | ForEach-Object {
                $version = $_.BaseName
                Write-Host "$name/$version"
            }
        }
    }

    'load' {
        $modulePath = Get-ModulePath $Args[1] $Args[2]

        if (($env:WmodLOADED) -and ($env:WmodLOADED.Contains($modulePath))) {
            warn 'The module is already loaded.'
        }
        else {
            . $modulePath

            # modify $env:PATH
            $env:PATH = $Path + $env:PATH

            # add environment variables
            if ($EnvVars) {
                $EnvVars.Keys | ForEach-Object {
                    New-Item -Path "Env:\$_" -Value $EnvVars[$_]
                }
            }

            $env:WmodLOADED += $modulePath
            Write-Host "$modulePath module loaded."
        }
    }

    'unload' {
        Unload-ByPath (Get-ModulePath $Args[1] $Args[2])
    }

    'purge' {
        $env:WmodLOADED | ForEach-Object {
            Unload-ByPath $_
        }
    }

    'list' {
        Write-Host "Loaded modules:"
        $env:WmodLOADED | ForEach-Object {
            Write-Host $_
        }
    }

    Default {
        $subCommand = $Args[0]
        error "'$subCommand' is not a valid command."
    }
}