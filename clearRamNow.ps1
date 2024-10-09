# Check for Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Warning "This script needs to be run as Administrator."
    exit
}

$ErrorActionPreference = 'Stop'

$rammapExe = Join-Path $env:windir "RAMMap64.exe"

# Define the shortcut path
$shortcutName = "Clear RAM Now.lnk"
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktopPath $shortcutName

if (Test-Path $rammapExe) {
    Write-Host "RAMMap64.exe already exists."

    # Check if the shortcut already exists
    if (-not (Test-Path $shortcutPath)) {
        Write-Host "Creating 'Clear RAM Now' shortcut on Desktop..."

        # Create a shortcut using WScript.Shell
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($shortcutPath)
        $shortcut.TargetPath = "$env:windir\RAMMap64.exe"
        $shortcut.Arguments = "-Ew"
        $shortcut.WorkingDirectory = $env:windir
        $shortcut.IconLocation = "$env:windir\RAMMap64.exe"
        $shortcut.Save()

        Write-Host "'Clear RAM Now' shortcut created successfully."
    } else {
        Write-Host "'Clear RAM Now' shortcut already exists on Desktop."
    }

    Write-Host "Running RAMMap64.exe -Ew..."
    & $rammapExe -Ew
} else {
    $zipUrl = "https://download.sysinternals.com/files/SysinternalsSuite.zip"
    $zipPath = "$env:TEMP\SysinternalsSuite.zip"
    $destinationPath = $env:windir

    try {
        # Download the Sysinternals Suite ZIP file
        Write-Host "RAMMap64.exe not found. Downloading Sysinternals Suite..."
        Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

        # Extract the ZIP file to the Windows directory
        Write-Host "Extracting files to $destinationPath ..."
        Expand-Archive -LiteralPath $zipPath -DestinationPath $destinationPath -Force

        # Create the shortcut after downloading
        if (-not (Test-Path $shortcutPath)) {
            Write-Host "Creating 'Clear RAM Now' shortcut on Desktop..."

            $shell = New-Object -ComObject WScript.Shell
            $shortcut = $shell.CreateShortcut($shortcutPath)
            $shortcut.TargetPath = "$env:windir\RAMMap64.exe"
            $shortcut.Arguments = "-Ew"
            $shortcut.WorkingDirectory = $env:windir
            $shortcut.IconLocation = "$env:windir\RAMMap64.exe"
            $shortcut.Save()

            Write-Host "'Clear RAM Now' shortcut created successfully."
        } else {
            Write-Host "'Clear RAM Now' shortcut already exists on Desktop."
        }

        # Run RAMMap64.exe with the -Ew parameter to clear Empty Working Sets
        Write-Host "Running RAMMap64.exe to clear Empty Working Sets..."
        & $rammapExe -Ew

        Write-Host "Memory has been cleared successfully."
    } catch {
        Write-Error "An error occurred: $_"
    }
}
