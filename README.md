# Wmod
An environment manage tool on windows, providing Lmod-like experiences.

> [!WARNING]
> This module is alpha and not fully tested. Currently, I just test it on PowerShell 7.

## Installation
Copy the whole repository to PowerShell module path and change the value of `Wmod_Path` in `wmod.psm1` to your install location.

## Usage

```powershell
# List available modules
Wmod-Avail

# Load/Unload a module
Wmod-Load $moduleName $version
Wmod-Unload $moduleName $version

# List loaded modules
Wmod-List
```

**How to write a module file**

This is an example. I have LLVM 18 installed at `C:\Program Files\LLVM`.

```powershell
$Path = 'C:\Program Files\LLVM\bin;'
```

You should place the file at `<Install Location>\ModuleFiles\<moduleName>\<version>.ps1`.
