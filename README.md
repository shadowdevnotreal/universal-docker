# Universal Docker Installer

![Screenshot_20240304_200921_Gallery](https://github.com/shadowdevnotreal/universal-docker/assets/43219706/da74af2f-5612-45c9-aa71-e67d15f93be9)

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
git clone https://github.com/shadowdevnotreal/universal-docker.git
```

3. Navigate to the cloned directory:

```bash
cd universal-docker
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
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/shadowdevnotreal/universal-docker/main/install-docker-windows.ps1" -OutFile "install-docker-windows.ps1"
```

4. Run the script:

```powershell
.\install-docker-windows.ps1
```

Please ensure you've met all the prerequisites for your operating system before running the installation scripts. The scripts will perform safety checks and guide you through the installation process.

**Note**: All scripts now include:
- Automatic detection of existing Docker installations
- System prerequisite validation
- Clear error messages and recovery instructions
- Step-by-step progress indicators

## Security Features

This installer implements several security measures:

- **Docker Engine (Linux)**: Uses Docker's official installation script from get.docker.com, which handles GPG verification of Docker packages
- **Docker Compose (Linux)**: Automatically verifies SHA256 checksums against GitHub releases to ensure file integrity
- **Existing Installation Detection**: Checks for and warns about existing Docker installations before overwriting
- **Prerequisite Validation**: Verifies system requirements before attempting installation

**For security-conscious users**:
- Linux: The get.docker.com script performs GPG signature verification automatically
- All platforms: You can manually verify downloads before running scripts if desired
- Docker Compose checksums are verified automatically on Linux installations

## Contribution
- Contributions are what make the open-source community such an amazing place to learn, inspire, and create.
- Any contributions you make are **greatly appreciated.**

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Feedback and Support

For support, feedback, or suggestions, please open an issue on the GitHub repository.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## Support This Project

If you find this project helpful, consider supporting future development:

<a href="https://www.buymeacoffee.com/diatasso" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-blue.png" alt="Buy Me A Coffee" style="height: 40px !important;width: 145px !important;" >
</a>
