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

    $modulePath = "$Wmod_ModulePath\$moduleName\$version.ps1"

    if (Test-Path $modulePath) {
        . $modulePath
        $env:PATH = $Path + $env:PATH
        $script:Wmod_Loaded += $modulePath
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
        $script:Wmod_Loaded = $script:Wmod_Loaded | Where-Object { $_ -ne $modulePath }
        Write-Host "$modulePath module unloaded."
    }
    else {
        Write-Host "$modulePath module not found."
    }
}

function Wmod-List {
    Write-Host "Loaded modules:"
    $script:Wmod_Loaded | ForEach-Object {
        Write-Host $_
    }
}
