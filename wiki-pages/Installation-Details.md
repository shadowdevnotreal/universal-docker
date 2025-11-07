# Installation Details

Comprehensive details on how installation works for each platform.

---

## Linux (Debian/Ubuntu)

### Docker Engine Installation

**Method:** Official Docker installation script from get.docker.com

**Process:**
1. System update: `apt-get update && apt-get upgrade`
2. Download: `curl -fsSL https://get.docker.com`
3. Execute with sudo privileges
4. GPG verification handled by get.docker.sh
5. Cleanup: Remove temporary get-docker.sh

**Docker Compose Installation:**
1. Fetch latest version from GitHub API
2. Fallback to v2.24.5 if API unavailable (rate limiting)
3. Download binary to `/usr/local/bin/docker-compose`
4. Download SHA256 checksum from GitHub releases
5. Verify integrity: `sha256sum` comparison
6. Set executable permissions: `chmod +x`

### Podman Installation

**Method:** APT package manager with kubic repository fallback

**Process:**
1. Attempt: `apt-get install -y podman`
2. Fallback: Add kubic repository for newer versions
   ```bash
   echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_$(lsb_release -rs)/ /" \
     | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
   ```
3. Add repository key
4. Install podman
5. Create Docker compatibility aliases in `~/.bashrc`
6. Install podman-compose via pip3

**Post-Install:**
```bash
alias docker='podman'
alias docker-compose='podman-compose'
```

---

## macOS

### Installation Method

**Docker Desktop** via DMG download and mount

### Architecture Detection

```bash
ARCH=$(uname -m)
# arm64 → Apple Silicon (M1/M2/M3)
# x86_64 → Intel
```

### Download URLs

- **Apple Silicon:** `https://desktop.docker.com/mac/main/arm64/Docker.dmg`
- **Intel:** `https://desktop.docker.com/mac/main/amd64/Docker.dmg`

### Installation Steps

1. Download DMG (~500MB)
2. Mount: `hdiutil attach Docker.dmg`
3. Copy to Applications: `sudo cp -R /Volumes/Docker/Docker.app /Applications`
4. Unmount: `hdiutil detach /Volumes/Docker`
5. Cleanup: Remove DMG file

### Minimum Requirements

- macOS 10.14 (Mojave) or newer
- Validation: `sw_vers -productVersion`

---

## Windows

### Installation Method

**Docker Desktop** via official installer

### Process

1. Display system requirements checklist
2. User confirms prerequisites
3. Download installer to `%USERPROFILE%\Downloads`
4. Execute: `Start-Process -FilePath DockerDesktopInstaller.exe -Args "install" -Wait`
5. Launch Docker Desktop

### System Requirements

- Windows 10 64-bit: Pro, Enterprise, Education (Build 15063+)
- Windows 11 64-bit: Any edition
- WSL 2 enabled
- Virtualization enabled in BIOS
- PowerShell with admin privileges

---

[⬅ Back to Home](Home)
