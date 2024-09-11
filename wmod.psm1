$Wmod_Path = "C:\Program Files\PowerShell\7\Modules\Wmod"
$Wmod_ModulePath = "$Wmod_Path\ModuleFiles"

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

    $modulePath = "$Wmod_ModulePath\$moduleName\$version.ps1"

    if (Test-Path $modulePath) {
        . $modulePath
        $env:PATH = $Path + $env:PATH
        Write-Host "$modulePath module loaded."
    }
    else {
        Write-Host "$modulePath module not found."
    }
}

function Wmod-Unload {
    param (
        [string]$moduleName,
        [string]$version
    )

    $modulePath = "$Wmod_ModulePath\$moduleName\$version.ps1"

    if (Test-Path $modulePath) {
        . $modulePath
        $env:PATH = $env:PATH.Replace($Path, '')
        Write-Host "$modulePath module unloaded."
    }
    else {
        Write-Host "$modulePath module not found."
    }
}