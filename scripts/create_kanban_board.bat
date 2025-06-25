@echo off
REM JambaM Login System Kanban Board Creator (Batch)
REM Simple wrapper for the PowerShell script

echo.
echo ========================================
echo   JambaM Login System Kanban Creator
echo ========================================
echo.

REM Check if GitHub token is provided
if "%1"=="" (
    echo ❌ Error: GitHub token is required
    echo.
    echo Usage: create_kanban_board.bat "your_github_token_here"
    echo.
    echo To get a GitHub token:
    echo 1. Go to GitHub Settings ^> Developer settings ^> Personal access tokens
    echo 2. Create a new token with repo and project permissions
    echo 3. Copy the token and use it as parameter
    echo.
    pause
    exit /b 1
)

echo 🚀 Starting Kanban board creation...
echo 📋 Repository: project-jambam
echo 🔑 Token: %1 (hidden for security)
echo.

REM Run the PowerShell script
powershell -ExecutionPolicy Bypass -File "%~dp0create_login_kanban_board.ps1" -GitHubToken "%1"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ Kanban board creation completed successfully!
    echo.
    echo 📝 Next steps:
    echo    1. Review the created project board
    echo    2. Assign tasks to team members
    echo    3. Set up automation rules
    echo    4. Begin Sprint 1 implementation
    echo.
) else (
    echo.
    echo ❌ Kanban board creation failed!
    echo.
    echo 🔧 Troubleshooting:
    echo    1. Check your GitHub token permissions
    echo    2. Verify repository access
    echo    3. Check internet connection
    echo    4. Review error messages above
    echo.
)

pause 