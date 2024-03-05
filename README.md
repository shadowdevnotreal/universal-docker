![Screenshot_20240304_200921_Gallery](https://github.com/shadowdevnotreal/universal-docker/assets/43219706/da74af2f-5612-45c9-aa71-e67d15f93be9)

# Universal Docker Installer

This repository contains scripts to automate the installation of Docker Desktop and Docker Engine across multiple operating systems including Linux, macOS, and Windows. The goal is to provide a seamless installation experience for Docker technologies regardless of the user's operating system.

## What This Tool Does

- **Linux**: Installs Docker Engine, Docker CLI, and Docker Compose.
- **macOS**: Automates the installation of Docker Desktop, which includes Docker Engine, Docker CLI, Docker Compose, Kubernetes, and Credential Helper.
- **Windows**: Provides a script to install Docker Desktop for Windows users.

## Prerequisites

- **Linux**: A Debian-based distribution (like Ubuntu), `curl` installed.
- **macOS**: Version 10.14 (Mojave) or newer.
- **Windows**: Windows 10 64-bit: Pro, Enterprise, or Education (Build 15063 or later), or Windows 11. PowerShell must be available, and WSL 2 must be enabled for Docker Desktop.

## Installation Instructions

### For Linux and macOS Users

1. Open a terminal window.
2. Clone the repository to your local machine:

```bash
git clone https://github.com/<your-username>/universal-docker-installer.git
```

3. Navigate to the cloned directory:

```bash
cd universal-docker-installer
```

4. Make the universal installer script executable:

```bash
chmod +x universal-installer.sh
```

5. Run the universal installer script:

```bash
./universal-installer.sh
```

The script will detect your operating system and prompt you to confirm the installation of the appropriate Docker setup for your system.

### For Windows Users

1. Open PowerShell as Administrator.
2. Navigate to where you want to download the script.
3. Download the PowerShell installation script:

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/<your-username>/universal-docker-installer/main/install-docker-windows.ps1" -OutFile "install-docker-windows.ps1"
```

4. Run the script:

```powershell
.\install-docker-windows.ps1
```

Please ensure you've met all the prerequisites for your operating system before running the installation scripts.

## Contributions

Contributions are welcome! If you have any improvements or bug fixes, please fork the repository, commit your changes, and submit a pull request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
```

Replace `<your-username>` with your GitHub username where the repository will be hosted. This README provides a clear guide for users to install Docker on their preferred operating system using your automated scripts. If there's anything else you'd like to add or modify, feel free to let me know!
