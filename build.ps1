# clean
Remove-Item -Path "$PSScriptRoot\dist\*" -Recurse -Force

# entry
Copy-Item "$PSScriptRoot\src\wmod.ps1" -Destination "$PSScriptRoot\dist"

# libs
New-Item -Path "$PSScriptRoot\dist" -Name "lib" -ItemType "directory" | Out-Null
Copy-Item -Path "$PSScriptRoot\src\*" -Destination "$PSScriptRoot\dist\lib" -Recurse -Exclude "wmod.ps1"

# modules
Copy-Item -Path "$PSScriptRoot\modules" -Destination "$PSScriptRoot\dist" -Recurse