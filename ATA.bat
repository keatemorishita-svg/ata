@echo off
title ATA — Atlas Time Archive
cd /d D:\Hi\Projects\ata

echo.
echo ========================================
echo   ATA — SAVING your workspace...
echo ========================================
echo.
powershell -ExecutionPolicy Bypass -File ".\ata.ps1" save

echo.
echo ========================================
echo   Done! Press any key to close...
echo ========================================
pause >nul
