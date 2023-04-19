# Display menu with title
Write-Host "⠀
        ⣀⣤⣤⣶⣶⣶⣶⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⠏⠉⠀⠈⠙⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⠿⠛⠋⠉⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⠁⠀⠀⠀⠀⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⡀⠀⠀⠀⣸⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣶⣶⣿⣿⡿⣿⣿⣿⣿⣿⠆⠀⠀⠀⠀
⠠⣀⠀⠀⠀⠀⠙⠿⢿⣿⣿⣿⡿⠟⠋⠀⠙⢿⡿⠋⠀⠠⠴⠶⣶⡄
⠀⠈⠛⠶⣦⣄⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⠶⠀⣿⠁
⠀⠀⠀⠀⠈⠙⠛⠿⢿⣿⣷⣶⣶⣶⣶⣶⣿⡿⠟⠛⠉⠁⠀⠐⠁⠀
"
Write-Host "regchecker v1.337 by daborond"

# Scan for registry entries
$registryPaths = @(
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
"HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"

)

$softwareNames = @()
Write-Host "Searching for installed software..."
foreach ($path in $registryPaths) {
    Write-Host "Searching in path: $path"
    $subKeys = Get-ChildItem $path
    foreach ($key in $subKeys) {
        $displayName = (Get-ItemProperty $key.PSPath).DisplayName
        if ($displayName) {
            # Add the software name to the array
            $softwareNames += $displayName
        }
    }
}

# Present final menu
Write-Host "Sorting software names..."
$softwareNames = $softwareNames | Sort-Object
Write-Host "Select a software from the list below:"
for ($i = 0; $i -lt $softwareNames.Count; $i++) {
    Write-Host "$($i + 1): $($softwareNames[$i])"
}
$selection = Read-Host "Enter the number of the software you want to select"
$softwareName = $softwareNames[$selection - 1]

Write-Host "Searching for selected software in the registry..."
foreach ($path in $registryPaths) {
    Write-Host "Searching in path: $path"
    $subKeys = Get-ChildItem $path
    foreach ($key in $subKeys) {
        $displayName = (Get-ItemProperty $key.PSPath).DisplayName
        if ($displayName -eq $softwareName) {
            Get-ItemProperty $key.PSPath | Format-List
        }
    }
}
