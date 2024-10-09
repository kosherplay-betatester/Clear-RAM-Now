@echo off
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
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
    REM Create a temporary VBS script to elevate permissions
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

set "RAMMAP_PATH=%windir%\RAMMap64.exe"
set "SHORTCUT_NAME=Clear RAM Now.lnk"
set "DESKTOP_PATH=%USERPROFILE%\Desktop"
set "SHORTCUT_PATH=%DESKTOP_PATH%\%SHORTCUT_NAME%"

if exist "%RAMMAP_PATH%" (
    echo RAMMap64.exe already exists.
) else (
    echo RAMMap64.exe not found. Downloading and installing...
    powershell -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://download.sysinternals.com/files/SysinternalsSuite.zip' -OutFile '%TEMP%\SysinternalsSuite.zip'"
    powershell -ExecutionPolicy Bypass -Command "Expand-Archive -LiteralPath '%TEMP%\SysinternalsSuite.zip' -DestinationPath '%windir%' -Force"
    if exist "%RAMMAP_PATH%" (
        echo RAMMap64.exe installed successfully.
    ) else (
        echo Failed to install RAMMap64.exe.
        pause
        exit
    )
)

if exist "%SHORTCUT_PATH%" (
    echo Shortcut 'Clear RAM Now' already exists on Desktop.
) else (
    echo Creating 'Clear RAM Now' shortcut on Desktop...
    powershell -ExecutionPolicy Bypass -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%SHORTCUT_PATH%'); $s.TargetPath = '%windir%\RAMMap64.exe'; $s.Arguments = '-Ew'; $s.IconLocation = '%windir%\RAMMap64.exe'; $s.WorkingDirectory = '%windir%'; $s.Save()"
    if exist "%SHORTCUT_PATH%" (
        echo Shortcut created successfully.
    ) else (
        echo Failed to create shortcut.
    )
)

echo Running RAMMap64.exe -Ew to clear Empty Working Sets...
"%RAMMAP_PATH%" -Ew

echo Memory has been cleared successfully.
pause
