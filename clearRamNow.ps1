# Check for Administrator privileges
# This block checks if the script is running with administrator rights. If not, it exits with a warning.
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Warning "This script needs to be run as Administrator."
    exit
}

# Set strict error handling to stop execution on any errors
$ErrorActionPreference = 'Stop'

# Define the path to RAMMap64.exe in the Windows directory
# This variable holds the path where RAMMap64.exe will be installed or where it should already be located.
$rammapExe = Join-Path $env:windir "RAMMap64.exe"

# Define the desktop shortcut path
# This defines the name and location of the shortcut that will be created on the user's desktop.
$shortcutName = "Clear RAM Now.lnk"
$desktopPath = [Environment]::GetFolderPath("Desktop")  # Get the user's Desktop path
$shortcutPath = Join-Path $desktopPath $shortcutName

# Check if RAMMap64.exe already exists
if (Test-Path $rammapExe) {
    # RAMMap64.exe exists, so we don't need to download it
    Write-Host "RAMMap64.exe already exists."

    # Check if the "Clear RAM Now" shortcut already exists on the Desktop
    if (-not (Test-Path $shortcutPath)) {
        # Create a desktop shortcut if it doesn't exist
        Write-Host "Creating 'Clear RAM Now' shortcut on Desktop..."

        # Use WScript.Shell to create the shortcut
        # This block creates a shortcut that runs RAMMap64.exe with the -Ew argument, which clears Empty Working Sets.
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($shortcutPath)
        $shortcut.TargetPath = "$env:windir\RAMMap64.exe"  # Set the target to RAMMap64.exe
        $shortcut.Arguments = "-Ew"  # Add the argument to clear Empty Working Sets
        $shortcut.WorkingDirectory = $env:windir  # Set the working directory to the Windows directory
        $shortcut.IconLocation = "$env:windir\RAMMap64.exe"  # Set the icon to RAMMap64.exe's icon
        $shortcut.Save()  # Save the shortcut to the Desktop

        Write-Host "'Clear RAM Now' shortcut created successfully."
    } else {
        # If the shortcut already exists, notify the user
        Write-Host "'Clear RAM Now' shortcut already exists on Desktop."
    }

    # Run RAMMap64.exe with the -Ew argument to clear Empty Working Sets
    Write-Host "Running RAMMap64.exe -Ew..."
    & $rammapExe -Ew  # Execute RAMMap64.exe with the -Ew argument to clear memory
} else {
    # If RAMMap64.exe doesn't exist, download and install it
    $zipUrl = "https://download.sysinternals.com/files/SysinternalsSuite.zip"  # URL to download the Sysinternals Suite ZIP file
    $zipPath = "$env:TEMP\SysinternalsSuite.zip"  # Temporary path to save the downloaded ZIP file
    $destinationPath = $env:windir  # Destination path where the ZIP will be extracted (Windows directory)

    try {
        # Download the Sysinternals Suite ZIP file
        Write-Host "RAMMap64.exe not found. Downloading Sysinternals Suite..."
        Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath  # Download the ZIP file from the official Sysinternals website

        # Extract the ZIP file to the Windows directory
        Write-Host "Extracting files to $destinationPath ..."
        Expand-Archive -LiteralPath $zipPath -DestinationPath $destinationPath -Force  # Extract the contents of the ZIP file to the Windows directory

        # Check if the shortcut needs to be created after downloading RAMMap64.exe
        if (-not (Test-Path $shortcutPath)) {
            # Create a desktop shortcut for RAMMap64.exe
            Write-Host "Creating 'Clear RAM Now' shortcut on Desktop..."

            $shell = New-Object -ComObject WScript.Shell  # Initialize WScript.Shell to create the shortcut
            $shortcut = $shell.CreateShortcut($shortcutPath)  # Create a new shortcut at the specified path
            $shortcut.TargetPath = "$env:windir\RAMMap64.exe"  # Set the target to RAMMap64.exe
            $shortcut.Arguments = "-Ew"  # Add the argument to clear Empty Working Sets
            $shortcut.WorkingDirectory = $env:windir  # Set the working directory to the Windows directory
            $shortcut.IconLocation = "$env:windir\RAMMap64.exe"  # Set the icon to RAMMap64.exe's icon
            $shortcut.Save()  # Save the shortcut to the Desktop

            Write-Host "'Clear RAM Now' shortcut created successfully."
        } else {
            # Notify the user if the shortcut already exists
            Write-Host "'Clear RAM Now' shortcut already exists on Desktop."
        }

        # Run RAMMap64.exe after installation to clear Empty Working Sets
        Write-Host "Running RAMMap64.exe to clear Empty Working Sets..."
        & $rammapExe -Ew  # Execute RAMMap64.exe with the -Ew argument to free memory

        Write-Host "Memory has been cleared successfully."
    } catch {
        # Catch any errors during the download or installation process and display an error message
        Write-Error "An error occurred: $_"
    }
}
