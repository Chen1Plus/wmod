$Wmod_Path = "C:\Program Files\PowerShell\7\Modules\Wmod"
$Wmod_ModulePath = "$Wmod_Path\ModuleFiles"

$script:Wmod_Loaded = @()

function Wmod-Avail {
    Get-ChildItem $Wmod_ModulePath -Directory | ForEach-Object {
        $name = $_.Name
        Get-ChildItem $_.FullName -Filter '*.ps1' | ForEach-Object {
            $version = $_.BaseName
            Write-Host "$name/$version"
        }
    }
}

function Wmod-Load {
    param (
        [string]$moduleName,
        [string]$version
    )

    $modulePath = Get-ModulePath $moduleName $version
    if ($script:Wmod_Loaded.Contains($modulePath)) {
        Write-Host 'Warning: The module is already loaded.'
    }
    elseif (Test-Path $modulePath) {
# main logic ==================================================================
        . $modulePath

        # modify $env:PATH
        $env:PATH = $Path + $env:PATH

        # add environment variables
        $EnvVars.Keys | ForEach-Object {
            New-Item -Path "Env:\$_" -Value $EnvVars[$_]
        }

        $script:Wmod_Loaded += $modulePath
        Write-Host "$modulePath module loaded."
# =============================================================================
    }
    else {
        Write-Host "Error: The module file is not found at $modulePath"
    }
}

function Wmod-Unload {
    param (
        [string]$moduleName,
        [string]$version
    )
    Unload-ByPath (Get-ModulePath $moduleName $version)
}

function Wmod-List {
    Write-Host "Loaded modules:"
    $script:Wmod_Loaded | ForEach-Object {
        Write-Host $_
    }
}

# Private
function Unload-ByPath {
    param (
        [string]$modulePath
    )
    
    if (-not $script:Wmod_Loaded.Contains($modulePath)) {
        Write-Host 'Error: The module is not loaded.'
    }
    elseif (-not (Test-Path $modulePath)) {
        Write-Host "Error: The module file is not found at $modulePath"
    }
    else {
        . $modulePath

        # modify $env:PATH
        $env:PATH = $env:PATH.Replace($Path, '')

        # remove environment variables
        $EnvVars.Keys | ForEach-Object {
            Remove-Item -Path "Env:\$_"
        }

        $script:Wmod_Loaded = $script:Wmod_Loaded | Where-Object { $_ -ne $modulePath }
        if (-not $script:Wmod_Loaded) {
            $script:Wmod_Loaded = @()
        }

        Write-Host "The module unloaded successfully."
    }
}

# Utilities
function Get-ModulePath {
    param (
        [string]$moduleName,
        [string]$version
    )
    return (Get-Item "$Wmod_ModulePath\$moduleName").GetFiles("$version.ps1").FullName
}