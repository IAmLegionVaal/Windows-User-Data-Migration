@echo off
setlocal
set /p "DEST=Enter the full destination folder for the migration: "
if not defined DEST (
    echo No destination was entered.
    pause
    exit /b 1
)
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Move-WindowsUserData.ps1" -Destination "%DEST%" -Copy
set "RC=%ERRORLEVEL%"
echo.
echo Windows User Data Migration finished with exit code %RC%.
pause
exit /b %RC%
