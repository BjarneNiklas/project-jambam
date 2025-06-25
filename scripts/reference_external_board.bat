@echo off
REM External Project Board Reference Script for JamBam
REM =================================================

echo 🚀 External Project Board Integration Script
echo ============================================

REM Check if GitHub token is provided
if "%1"=="" (
    echo ❌ Error: GitHub token not provided
    echo.
    echo Usage: reference_external_board.bat ^<github_token^>
    echo.
    echo Example: reference_external_board.bat ghp_xxxxxxxxxxxxxxxxxxxx
    echo.
    echo Or set environment variable:
    echo   set GITHUB_TOKEN=your_token_here
    echo   reference_external_board.bat
    echo.
    pause
    exit /b 1
)

REM Set GitHub token
set GITHUB_TOKEN=%1

echo 🔍 Using GitHub token: %GITHUB_TOKEN:~0,10%...
echo.

REM Check if PowerShell is available
powershell -Command "Write-Host 'PowerShell available'" >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Error: PowerShell is required but not available
    echo Please install PowerShell 7.0 or later
    pause
    exit /b 1
)

REM Check if Python is available
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo 🐍 Using Python script...
    echo.
    python scripts/reference_external_board.py
) else (
    echo 💻 Using PowerShell script...
    echo.
    powershell -ExecutionPolicy Bypass -File "scripts/reference_external_board.ps1" -GitHubToken "%GITHUB_TOKEN%"
)

echo.
echo ✅ Script execution completed
pause 