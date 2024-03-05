# Download Docker Desktop Installer
Invoke-WebRequest -Uri "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe" -OutFile "$Env:USERPROFILE\Downloads\DockerDesktopInstaller.exe"

# Install Docker Desktop
Start-Process -FilePath "$Env:USERPROFILE\Downloads\DockerDesktopInstaller.exe" -Args "install" -Wait

# Start Docker Desktop
Start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe"
