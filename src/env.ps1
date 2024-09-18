. $PSScriptRoot\log.ps1

$MODULEPATH = (Split-Path -Path $PSScriptRoot -Parent) + '\modules'
if (-not (Test-Path $MODULEPATH)) {
    error "The module path is invalid."
}

if (-not $env:WmodLOADED) {
    New-Item -Path "Env:\WmodLOADED" -Value @() | Out-Null
}