@echo off
REM Universal Docker Toolkit - Windows Starter
REM Version: 2.0.0
REM Main entry point for Windows users

setlocal EnableDelayedExpansion

REM Enable ANSI colors on Windows 10+
for /F "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%VERSION%" geq "10.0" (
    REM Enable virtual terminal processing for colors
    reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1
)

REM Color codes (ANSI escape sequences - works on Windows 10+)
set "GREEN=[92m"
set "BLUE=[94m"
set "YELLOW=[93m"
set "RED=[91m"
set "CYAN=[96m"
set "MAGENTA=[95m"
set "NC=[0m"

REM Detect if Docker or Podman is installed
set "DOCKER_INSTALLED=false"
set "PODMAN_INSTALLED=false"
set "WSL_AVAILABLE=false"
set "RUNTIME_NAME=Not Installed"

docker --version >nul 2>&1
if %errorlevel% equ 0 (
    set "DOCKER_INSTALLED=true"
    set "RUNTIME_NAME=Docker"
)

podman --version >nul 2>&1
if %errorlevel% equ 0 (
    set "PODMAN_INSTALLED=true"
    if "%DOCKER_INSTALLED%"=="false" (
        set "RUNTIME_NAME=Podman"
    ) else (
        set "RUNTIME_NAME=Docker ^& Podman"
    )
)

wsl --status >nul 2>&1
if %errorlevel% equ 0 (
    set "WSL_AVAILABLE=true"
)

:MAIN_MENU
cls
echo %CYAN%============================================================%NC%
echo.
echo          %MAGENTA%^🐳 Universal Docker Toolkit ^🐳%NC%
echo                   %GREEN%Version 2.0.0%NC%
echo.
echo %CYAN%============================================================%NC%
echo.
echo %BLUE%Platform:%NC% Windows
echo %BLUE%Runtime:%NC% %RUNTIME_NAME%

if "%DOCKER_INSTALLED%"=="true" (
    echo %GREEN%● Docker is installed%NC%
    docker --version 2>nul
)

if "%PODMAN_INSTALLED%"=="true" (
    echo %GREEN%● Podman is installed%NC%
    podman --version 2>nul
)

if "%DOCKER_INSTALLED%"=="false" if "%PODMAN_INSTALLED%"=="false" (
    echo %RED%● No container runtime installed%NC%
)
echo.

if "%WSL_AVAILABLE%"=="true" (
    echo %GREEN%● WSL is available%NC% ^(for Manager ^& Packager tools^)
) else (
    echo %YELLOW%● WSL not detected%NC% ^(needed for Manager ^& Packager^)
)
echo.
echo %CYAN%============================================================%NC%
echo %YELLOW%  What would you like to do?%NC%
echo %CYAN%============================================================%NC%
echo.

if "%DOCKER_INSTALLED%"=="false" if "%PODMAN_INSTALLED%"=="false" (
    echo   %YELLOW%1.%NC% Install Docker/Podman            %GREEN%[Start Here!]%NC%
) else (
    echo   %GREEN%1.%NC% Install Docker/Podman            [Reinstall/Add]
)

set "RUNTIME_READY=false"
if "%DOCKER_INSTALLED%"=="true" set "RUNTIME_READY=true"
if "%PODMAN_INSTALLED%"=="true" set "RUNTIME_READY=true"

if "%RUNTIME_READY%"=="true" if "%WSL_AVAILABLE%"=="true" (
    echo   %GREEN%2.%NC% Manage Containers                %CYAN%[Launch WSL]%NC%
    echo   %GREEN%3.%NC% Package Applications             [Launch WSL]
) else (
    echo   %YELLOW%2.%NC% Manage Containers                %RED%[WSL Required]%NC%
    echo   %YELLOW%3.%NC% Package Applications             %RED%[WSL Required]%NC%
)

if "%RUNTIME_READY%"=="true" (
    echo   %GREEN%4.%NC% Uninstall Docker/Podman
) else (
    echo   %YELLOW%4.%NC% Uninstall Docker/Podman          %RED%[Nothing to Remove]%NC%
)

echo.
echo   %BLUE%5.%NC% About / Help
echo   %BLUE%6.%NC% Exit
echo.
echo %CYAN%============================================================%NC%
echo.

set /p "choice=Enter your choice (1-6): "
echo.

if "%choice%"=="1" goto INSTALL_DOCKER
if "%choice%"=="2" goto LAUNCH_MANAGER
if "%choice%"=="3" goto LAUNCH_PACKAGER
if "%choice%"=="4" goto UNINSTALL_DOCKER
if "%choice%"=="5" goto SHOW_ABOUT
if "%choice%"=="6" goto EXIT_SCRIPT

echo %RED%Invalid choice. Please enter 1-6.%NC%
timeout /t 2 >nul
goto MAIN_MENU

:INSTALL_DOCKER
cls
echo %BLUE%============================================================%NC%
echo %YELLOW%  Install Docker/Podman%NC%
echo %BLUE%============================================================%NC%
echo.

if "%DOCKER_INSTALLED%"=="true" (
    echo %GREEN%Docker is already installed%NC%
    docker --version
    echo.
)

if "%PODMAN_INSTALLED%"=="true" (
    echo %GREEN%Podman is already installed%NC%
    podman --version
    echo.
)

if "%DOCKER_INSTALLED%"=="true" (
    set /p "confirm=Do you want to install another runtime or reinstall? (y/n): "
    if /i not "!confirm!"=="y" goto MAIN_MENU
    echo.
) else if "%PODMAN_INSTALLED%"=="true" (
    set /p "confirm=Do you want to install another runtime or reinstall? (y/n): "
    if /i not "!confirm!"=="y" goto MAIN_MENU
    echo.
)

if exist "install-docker-windows.ps1" (
    echo %CYAN%Launching PowerShell installer...%NC%
    echo.
    echo %YELLOW%Note: You may need to run this as Administrator%NC%
    echo.
    pause
    powershell -ExecutionPolicy Bypass -File "install-docker-windows.ps1"
    echo.
    echo %GREEN%Installation process completed!%NC%
    echo.
) else (
    echo %RED%Error: install-docker-windows.ps1 not found!%NC%
    echo.
    echo Please make sure all script files are in the same directory.
    echo.
    echo %CYAN%Alternative: Download Docker Desktop manually:%NC%
    echo https://www.docker.com/products/docker-desktop
    echo.
)

pause
goto MAIN_MENU

:LAUNCH_MANAGER
cls
echo %BLUE%============================================================%NC%
echo %YELLOW%  Container Manager%NC%
echo %BLUE%============================================================%NC%
echo.

if "%DOCKER_INSTALLED%"=="false" (
    echo %RED%Docker is not installed!%NC%
    echo.
    echo Please install Docker Desktop first ^(Option 1^).
    echo.
    pause
    goto MAIN_MENU
)

if "%WSL_AVAILABLE%"=="false" (
    echo %YELLOW%WSL ^(Windows Subsystem for Linux^) is required!%NC%
    echo.
    echo The Container Manager is a bash script that runs in WSL.
    echo.
    echo %CYAN%To install WSL:%NC%
    echo   1. Open PowerShell as Administrator
    echo   2. Run: wsl --install
    echo   3. Restart your computer
    echo   4. Run this tool again
    echo.
    echo %CYAN%Alternative:%NC% Use Docker Desktop's built-in GUI
    echo.
    pause
    goto MAIN_MENU
)

if not exist "docker-manager.sh" (
    echo %RED%Error: docker-manager.sh not found!%NC%
    echo.
    echo Please make sure all script files are in the same directory.
    echo.
    pause
    goto MAIN_MENU
)

echo %CYAN%Launching Container Manager in WSL...%NC%
echo.
wsl bash docker-manager.sh
echo.
pause
goto MAIN_MENU

:LAUNCH_PACKAGER
cls
echo %BLUE%============================================================%NC%
echo %YELLOW%  Application Packager%NC%
echo %BLUE%============================================================%NC%
echo.

if "%DOCKER_INSTALLED%"=="false" (
    echo %RED%Docker is not installed!%NC%
    echo.
    echo Please install Docker Desktop first ^(Option 1^).
    echo.
    pause
    goto MAIN_MENU
)

if "%WSL_AVAILABLE%"=="false" (
    echo %YELLOW%WSL ^(Windows Subsystem for Linux^) is required!%NC%
    echo.
    echo The Application Packager is a bash script that runs in WSL.
    echo.
    echo %CYAN%To install WSL:%NC%
    echo   1. Open PowerShell as Administrator
    echo   2. Run: wsl --install
    echo   3. Restart your computer
    echo   4. Run this tool again
    echo.
    pause
    goto MAIN_MENU
)

if not exist "docker-packager.sh" (
    echo %RED%Error: docker-packager.sh not found!%NC%
    echo.
    echo Please make sure all script files are in the same directory.
    echo.
    pause
    goto MAIN_MENU
)

echo %CYAN%Launching Application Packager in WSL...%NC%
echo.
wsl bash docker-packager.sh
echo.
pause
goto MAIN_MENU

:UNINSTALL_DOCKER
cls
echo %BLUE%============================================================%NC%
echo %YELLOW%  Uninstall Docker Desktop%NC%
echo %BLUE%============================================================%NC%
echo.

if "%DOCKER_INSTALLED%"=="false" (
    echo %YELLOW%Docker is not installed!%NC%
    echo.
    echo Nothing to uninstall.
    echo.
    pause
    goto MAIN_MENU
)

echo %RED%WARNING: This will remove Docker Desktop from your system!%NC%
echo.
echo %YELLOW%Docker Desktop can be uninstalled through:%NC%
echo   1. Windows Settings ^> Apps ^> Docker Desktop ^> Uninstall
echo   2. Control Panel ^> Programs ^> Uninstall a program
echo.
echo %CYAN%This will:%NC%
echo   - Remove Docker Desktop application
echo   - Stop all running containers
echo   - You can choose to keep or remove data during uninstall
echo.
set /p "confirm=Press Enter to open Windows Settings, or Ctrl+C to cancel..."
echo.

start ms-settings:appsfeatures
echo.
echo %GREEN%Opening Windows Settings...%NC%
echo Find "Docker Desktop" in the list and click Uninstall.
echo.
pause
goto MAIN_MENU

:SHOW_ABOUT
cls
echo %BLUE%============================================================%NC%
echo %YELLOW%  About Universal Docker Toolkit%NC%
echo %BLUE%============================================================%NC%
echo.
echo %CYAN%What is this toolkit?%NC%
echo A complete solution for Docker on Windows, Linux, and macOS.
echo Everything you need in one place!
echo.
echo %CYAN%Features:%NC%
echo   %GREEN%●%NC% Install Docker Desktop OR Podman Desktop
echo   %GREEN%●%NC% Manage containers with interactive menus
echo   %GREEN%●%NC% Create Dockerfiles for your projects
echo   %GREEN%●%NC% Generate Docker Compose configurations
echo   %GREEN%●%NC% Build and test containers interactively
echo   %GREEN%●%NC% Works with Docker AND Podman seamlessly
echo.
echo %CYAN%Windows Notes:%NC%
echo   • Choose Docker Desktop OR Podman Desktop
echo   • WSL recommended for Manager and Packager tools
echo   • PowerShell installer handles setup automatically
echo   • Bash tools can run in WSL, Git Bash, or Cygwin
echo   • Podman Desktop is lighter and uses less resources
echo.
echo %CYAN%Perfect for:%NC%
echo   • Beginners learning containers
echo   • Developers wanting quick setup
echo   • DevOps managing multiple projects
echo.
echo %CYAN%Supported Platforms:%NC%
echo   • Windows 10/11 ^(with WSL for bash tools^)
echo   • Linux ^(Ubuntu/Debian^)
echo   • macOS ^(Intel ^& Apple Silicon^)
echo.
echo %CYAN%Repository:%NC%
echo   https://github.com/shadowdevnotreal/universal-docker
echo.
echo %CYAN%Tools Included:%NC%
echo   1. Docker/Podman Installer    - Install Docker or Podman
echo   2. Container Manager          - Manage running containers ^(WSL^)
echo   3. Application Packager       - Create Dockerfiles ^(WSL^)
echo   4. Uninstall Guide            - Remove Docker/Podman
echo.
echo %CYAN%Quick Start:%NC%
echo   1. Install Docker Desktop ^(Option 1^)
echo   2. Install WSL if you want Manager/Packager tools
echo   3. Use Docker Desktop GUI or launch bash tools in WSL
echo.
pause
goto MAIN_MENU

:EXIT_SCRIPT
cls
echo %GREEN%============================================================%NC%
echo.
echo   %CYAN%Thanks for using Universal Docker Toolkit!%NC% ^🐳
echo.
echo %GREEN%============================================================%NC%
echo.
exit /b 0
