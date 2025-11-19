# Universal Docker Installer - Windows Script
# Version: 1.0.0
# Installs Docker Desktop on Windows 10/11

# Docker Desktop for Windows - System Requirements Check
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Docker Desktop System Requirements" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Before proceeding, ensure your system meets these requirements:" -ForegroundColor Yellow
Write-Host "  - Windows 10 64-bit: Pro, Enterprise, or Education (Build 15063 or later)" -ForegroundColor White
Write-Host "  - OR Windows 11 64-bit: Home, Pro, Enterprise, or Education" -ForegroundColor White
Write-Host "  - WSL 2 must be enabled" -ForegroundColor White
Write-Host "  - PowerShell must be run as Administrator" -ForegroundColor White
Write-Host "  - Virtualization must be enabled in BIOS" -ForegroundColor White
Write-Host ""

# Check if Docker is already installed
if (Get-Command docker -ErrorAction SilentlyContinue) {
    Write-Host "Docker is already installed:" -ForegroundColor Green
    docker --version
    Write-Host ""
    $response = Read-Host "Do you want to continue anyway? This may overwrite your current installation (y/n)"
    if ($response -ne 'y' -and $response -ne 'Y') {
        Write-Host "Installation aborted." -ForegroundColor Yellow
        exit 0
    }
}

# Confirm user has verified requirements
$confirm = Read-Host "Have you verified all requirements above? (y/n)"
if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host "Installation aborted. Please verify requirements and try again." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Installation Options:" -ForegroundColor Cyan
Write-Host "  1. Auto-install Docker Desktop (download + install automatically)" -ForegroundColor White
Write-Host "  2. Show download link only (manual installation)" -ForegroundColor White
Write-Host ""
$choice = Read-Host "Select option (1 or 2)"

if ($choice -eq '2') {
    Write-Host ""
    Write-Host "======================================" -ForegroundColor Green
    Write-Host "Manual Installation Instructions" -ForegroundColor Green
    Write-Host "======================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Download Docker Desktop from:" -ForegroundColor Yellow
    Write-Host "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Or visit: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "After downloading:" -ForegroundColor White
    Write-Host "  1. Run the installer as Administrator" -ForegroundColor White
    Write-Host "  2. Follow the installation wizard" -ForegroundColor White
    Write-Host "  3. Restart your computer when prompted" -ForegroundColor White
    Write-Host "  4. Launch Docker Desktop from Start menu" -ForegroundColor White
    Write-Host ""
    exit 0
}

Write-Host ""
Write-Host "Proceeding with automatic installation..." -ForegroundColor Green
Write-Host ""

# Download Docker Desktop Installer
Write-Host "[Step 1/3] Downloading Docker Desktop..." -ForegroundColor Cyan
Write-Host "This may take several minutes (~500MB)..." -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe" -OutFile "$Env:USERPROFILE\Downloads\DockerDesktopInstaller.exe"
    Write-Host "✓ Download complete" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "ERROR: Failed to download Docker Desktop" -ForegroundColor Red
    Write-Host "Please check your internet connection and try again." -ForegroundColor Yellow
    Write-Host "Or use option 2 to download manually." -ForegroundColor Yellow
    exit 1
}

# Install Docker Desktop
Write-Host "[Step 2/3] Installing Docker Desktop..." -ForegroundColor Cyan
Write-Host "The installer window will open. Please follow the prompts." -ForegroundColor Yellow
try {
    Start-Process -FilePath "$Env:USERPROFILE\Downloads\DockerDesktopInstaller.exe" -Args "install" -Wait
    Write-Host "✓ Installation complete" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "ERROR: Installation failed" -ForegroundColor Red
    Write-Host "The installer file is saved at: $Env:USERPROFILE\Downloads\DockerDesktopInstaller.exe" -ForegroundColor Yellow
    Write-Host "You can try running it manually as Administrator." -ForegroundColor Yellow
    exit 1
}

# Start Docker Desktop
Write-Host "[Step 3/3] Starting Docker Desktop..." -ForegroundColor Cyan
try {
    Start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    Write-Host "✓ Docker Desktop started" -ForegroundColor Green
} catch {
    Write-Host "Note: Could not auto-start Docker Desktop" -ForegroundColor Yellow
    Write-Host "Please launch it manually from the Start menu" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "  - Docker Desktop will complete setup on first launch" -ForegroundColor White
Write-Host "  - You may need to restart your computer" -ForegroundColor White
Write-Host "  - After restart, launch Docker Desktop from Start menu" -ForegroundColor White
Write-Host "  - Test Docker: docker run hello-world" -ForegroundColor White
Write-Host ""
