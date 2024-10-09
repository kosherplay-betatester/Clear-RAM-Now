@echo off
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for Administrator privileges by attempting to access a system-protected file.
REM If the user doesn't have admin rights, the script will try to elevate itself using UAC.

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If the error level is not 0, it means the user does not have administrator rights.
if '%errorlevel%' NEQ '0' (
    echo ===========================================================================
    echo This script requires administrative privileges to run.
    echo Please press any key to request elevation.
    echo ===========================================================================
    pause
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    REM Create a temporary VBScript to elevate the script using UAC.
    REM The VBScript runs the same batch file with elevated privileges.

    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    
    REM Run the temporary VBScript to trigger the UAC prompt.
    "%temp%\getadmin.vbs"

    REM Once the script has been elevated, delete the temporary VBScript.
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    REM The script now runs with admin privileges, so we can proceed with the rest of the operations.
    pushd "%CD%"  REM Save the current directory.
    CD /D "%~dp0" REM Change the directory to the script's location.

:--------------------------------------

REM Define variables for paths and file names used in the script.

set "RAMMAP_PATH=%windir%\RAMMap64.exe"    REM Path to the RAMMap executable in the Windows directory.
set "SHORTCUT_NAME=Clear RAM Now.lnk"      REM Name of the desktop shortcut that will be created.
set "DESKTOP_PATH=%USERPROFILE%\Desktop"   REM Path to the current user's desktop.
set "SHORTCUT_PATH=%DESKTOP_PATH%\%SHORTCUT_NAME%"  REM Full path for the desktop shortcut.

REM Check if RAMMap64.exe already exists in the Windows directory.

if exist "%RAMMAP_PATH%" (
    echo RAMMap64.exe already exists.
) else (
    REM If RAMMap64.exe does not exist, download and install it.

    echo RAMMap64.exe not found. Downloading and installing...
    
    REM Use PowerShell to download the Sysinternals Suite from the official Microsoft URL.
    powershell -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://download.sysinternals.com/files/SysinternalsSuite.zip' -OutFile '%TEMP%\SysinternalsSuite.zip'"

    REM Use PowerShell to extract the downloaded ZIP file into the Windows directory.
    powershell -ExecutionPolicy Bypass -Command "Expand-Archive -LiteralPath '%TEMP%\SysinternalsSuite.zip' -DestinationPath '%windir%' -Force"

    REM After extracting, check if RAMMap64.exe now exists in the Windows directory.
    if exist "%RAMMAP_PATH%" (
        echo RAMMap64.exe installed successfully.
    ) else (
        REM If something went wrong with the download or extraction, display an error message and exit.
        echo Failed to install RAMMap64.exe.
        pause
        exit
    )
)

REM Check if the desktop shortcut already exists.

if exist "%SHORTCUT_PATH%" (
    REM If the shortcut already exists, no need to create it again.
    echo Shortcut 'Clear RAM Now' already exists on Desktop.
) else (
    REM If the shortcut doesn't exist, create it.

    echo Creating 'Clear RAM Now' shortcut on Desktop...
    
    REM Use PowerShell to create a new shortcut on the user's desktop that will run RAMMap64.exe with the -Ew argument.
    powershell -ExecutionPolicy Bypass -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%SHORTCUT_PATH%'); $s.TargetPath = '%windir%\RAMMap64.exe'; $s.Arguments = '-Ew'; $s.IconLocation = '%windir%\RAMMap64.exe'; $s.WorkingDirectory = '%windir%'; $s.Save()"

    REM Check if the shortcut was created successfully.
    if exist "%SHORTCUT_PATH%" (
        echo Shortcut created successfully.
    ) else (
        REM If something went wrong, display an error message.
        echo Failed to create shortcut.
    )
)

REM Now, run RAMMap64.exe with the -Ew argument to clear Empty Working Sets and free up memory.

echo Running RAMMap64.exe -Ew to clear Empty Working Sets...
"%RAMMAP_PATH%" -Ew

REM If the command runs successfully, display a success message.
echo Memory has been cleared successfully.

REM Pause to allow the user to see the result before the script closes.
pause
