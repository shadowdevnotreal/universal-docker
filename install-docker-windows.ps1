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

Write-Host "Proceeding with installation..." -ForegroundColor Green
Write-Host ""

# Download Docker Desktop Installer
Invoke-WebRequest -Uri "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe" -OutFile "$Env:USERPROFILE\Downloads\DockerDesktopInstaller.exe"

# Install Docker Desktop
Start-Process -FilePath "$Env:USERPROFILE\Downloads\DockerDesktopInstaller.exe" -Args "install" -Wait

# Start Docker Desktop
Start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe"
