@echo off
title ATA — Atlas Time Archive
cd /d D:\Hi\Projects\ata

:: Get today's date
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set td=%%I
set td=%td:~0,8%

:: Check for today's snapshot
dir /b "%APPDATA%\ATA\snapshots\ata-%td%*.json" >nul 2>&1

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo   Today's snapshot FOUND.
    echo   RESTORING your workspace now...
    echo ========================================
    echo.
    powershell -ExecutionPolicy Bypass -File ".\ata.ps1" restore -SkipMissing -Yes
) else (
    echo.
    echo ========================================
    echo   No snapshot for today yet.
    echo   SAVING your workspace now...
    echo ========================================
    echo.
    powershell -ExecutionPolicy Bypass -File ".\ata.ps1" save
)

echo.
echo Done. You can close this window.
pause >nul
