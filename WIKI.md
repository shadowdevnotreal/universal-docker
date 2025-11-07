# Universal Docker Installer - Technical Wiki

<div align="center">

**Technical Documentation for Developers and System Administrators**

[Installation Details](#installation-details) • [Architecture](#architecture) • [Security](#security) • [Troubleshooting](#troubleshooting) • [Contributing](#contributing)

</div>

---

## Table of Contents

- [Overview](#overview)
- [System Architecture](#system-architecture)
- [Installation Details](#installation-details)
- [Script Specifications](#script-specifications)
- [Security Implementation](#security-implementation)
- [Container Manager Architecture](#container-manager-architecture)
- [Platform-Specific Details](#platform-specific-details)
- [Troubleshooting](#troubleshooting)
- [Advanced Configuration](#advanced-configuration)
- [Contributing](#contributing)
- [API Reference](#api-reference)

---

## Overview

### Project Structure

```
universal-docker/
├── universal-installer.sh      # Main entry point (Linux/macOS)
├── install-docker-linux.sh     # Linux-specific installer
├── install-docker-mac.sh       # macOS-specific installer
├── install-docker-windows.ps1  # Windows-specific installer
├── docker-manager.sh           # Interactive container management tool (v2.0)
├── README.md                   # User-friendly documentation
├── WIKI.md                     # Technical documentation (this file)
├── TODO.md                     # Development roadmap
└── LICENSE                     # MIT License
```

### Version Information

| Component | Version | Language | Lines of Code |
|-----------|---------|----------|---------------|
| universal-installer.sh | 1.0.0 | Bash | ~50 |
| install-docker-linux.sh | 1.0.0 | Bash | ~230 |
| install-docker-mac.sh | 1.0.0 | Bash | ~150 |
| install-docker-windows.ps1 | 1.0.0 | PowerShell | ~110 |
| docker-manager.sh | 2.0.0 | Bash | ~610 |

---

## System Architecture

### High-Level Flow

```
┌─────────────────────────────────────────────┐
│         User Executes Installer            │
└──────────────────┬──────────────────────────┘
                   │
                   ▼
         ┌─────────────────────┐
         │  OS Detection       │
         │  (uname -s)         │
         └──────┬──────────────┘
                │
    ┌───────────┼───────────┐
    │           │           │
    ▼           ▼           ▼
┌────────┐  ┌────────┐  ┌──────────┐
│ Linux  │  │ macOS  │  │ Windows  │
└───┬────┘  └───┬────┘  └────┬─────┘
    │           │            │
    ▼           ▼            ▼
┌────────────────────────────────────┐
│   Platform-Specific Installer      │
│   - Prerequisites Check            │
│   - Docker/Podman Installation     │
│   - Post-Install Configuration     │
│   - Container Manager Offer        │
└────────────────────────────────────┘
```

### Linux Installation Flow

```
┌──────────────────────────────────────┐
│  install-docker-linux.sh             │
└──────────────┬───────────────────────┘
               │
               ▼
    ┌──────────────────────┐
    │  Existing Install?   │
    │  (command -v docker) │
    └─────┬────────────────┘
          │
    Yes ──┼── No
          │     │
          ▼     ▼
    ┌─────────────────┐
    │ Warn User &     │
    │ Ask to Continue │
    └─────┬───────────┘
          │
          ▼
    ┌──────────────────────┐
    │  User Choice:        │
    │  1. Docker Engine    │
    │  2. Podman           │
    └─────┬────────────────┘
          │
    ┌─────┴─────┐
    │           │
    ▼           ▼
┌──────────┐  ┌───────────┐
│ Docker   │  │  Podman   │
│ Install  │  │  Install  │
└──────────┘  └───────────┘
    │             │
    └──────┬──────┘
           ▼
    ┌──────────────────┐
    │ Docker Compose / │
    │ podman-compose   │
    └─────┬────────────┘
          │
          ▼
    ┌──────────────────┐
    │ SHA256 Verify    │
    │ (Docker Compose) │
    └─────┬────────────┘
          │
          ▼
    ┌──────────────────┐
    │ Offer Container  │
    │ Manager Launch   │
    └──────────────────┘
```

---

## Installation Details

### Linux (Debian/Ubuntu)

#### Docker Engine Installation

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

#### Podman Installation

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

### macOS

#### Installation Method

**Docker Desktop** via DMG download and mount

**Architecture Detection:**
```bash
ARCH=$(uname -m)
# arm64 → Apple Silicon (M1/M2/M3)
# x86_64 → Intel
```

**Download URLs:**
- Apple Silicon: `https://desktop.docker.com/mac/main/arm64/Docker.dmg`
- Intel: `https://desktop.docker.com/mac/main/amd64/Docker.dmg`

**Installation Steps:**
1. Download DMG (~500MB)
2. Mount: `hdiutil attach Docker.dmg`
3. Copy to Applications: `sudo cp -R /Volumes/Docker/Docker.app /Applications`
4. Unmount: `hdiutil detach /Volumes/Docker`
5. Cleanup: Remove DMG file

**Minimum Requirements:**
- macOS 10.14 (Mojave) or newer
- Validation: `sw_vers -productVersion`

### Windows

#### Installation Method

**Docker Desktop** via official installer

**Process:**
1. Display system requirements checklist
2. User confirms prerequisites
3. Download installer to `%USERPROFILE%\Downloads`
4. Execute: `Start-Process -FilePath DockerDesktopInstaller.exe -Args "install" -Wait`
5. Launch Docker Desktop

**System Requirements:**
- Windows 10 64-bit: Pro, Enterprise, Education (Build 15063+)
- Windows 11 64-bit: Any edition
- WSL 2 enabled
- Virtualization enabled in BIOS
- PowerShell with admin privileges

---

## Script Specifications

### Error Handling

All Bash scripts use:
```bash
set -euo pipefail
```

**Meaning:**
- `set -e`: Exit immediately if any command fails
- `set -u`: Treat unset variables as errors
- `set -o pipefail`: Pipe failures propagate

### Logging

**Output Levels:**
- ✓ Success indicators (green checkmarks)
- ⚠️ Warnings (yellow text)
- ❌ Errors (red text)
- ℹ️ Information (blue text)

**Example:**
```bash
echo "✓ Docker Engine installed"
echo "WARNING: Could not verify checksum"
echo "ERROR: Failed to download"
```

### User Interactions

**Confirmation Prompts:**
```bash
read -p "Do you want to continue? (y/n): " response
case $response in
    [Yy]*) proceed ;;
    *) abort ;;
esac
```

**Pause Points:**
```bash
read -p "Press Enter to continue or Ctrl+C to cancel..."
```

---

## Security Implementation

### Threat Model

**Protected Against:**
- ✅ Corrupted downloads (SHA256 verification)
- ✅ Man-in-the-middle attacks (HTTPS + checksums)
- ✅ Accidental overwrites (existing installation detection)
- ✅ Privilege escalation (explicit sudo prompts)
- ✅ Untrusted sources (official repositories only)

**NOT Protected Against:**
- ❌ Compromised official repositories (beyond our control)
- ❌ Local system compromise (if already rooted)
- ❌ Social engineering attacks

### Checksum Verification

**Docker Compose Only** (Linux)

**Implementation:**
```bash
# Download checksum file
COMPOSE_CHECKSUM_URL="https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-${OS}-${ARCH}.sha256"

# Extract expected hash
EXPECTED=$(cat checksum.sha256 | awk '{print $1}')

# Calculate actual hash
ACTUAL=$(sha256sum /usr/local/bin/docker-compose | awk '{print $1}')

# Compare
if [ "$EXPECTED" = "$ACTUAL" ]; then
    echo "✓ Verified"
else
    echo "WARNING: Checksum mismatch!"
    # User choice to proceed or abort
fi
```

**Why Docker Engine not verified:**
- Docker's official get.docker.sh handles GPG verification
- Package manager (apt/yum) verifies signatures
- We delegate to official, trusted mechanisms

### HTTPS Enforcement

All downloads use HTTPS:
- `curl -fsSL https://...`
- Enforced SSL certificate validation
- No HTTP fallback

### Privilege Management

**Principle of Least Privilege:**
- Scripts run as regular user
- `sudo` only when necessary:
  - Package installation
  - System file modifications
  - Service management

**User Awareness:**
```bash
if ! sudo -n true 2>/dev/null; then
    echo "This script requires sudo privileges."
    echo "You may be prompted for your password."
fi
```

---

## Container Manager Architecture

### Design Philosophy

**Goals:**
1. Zero command memorization
2. Visual feedback (colors, status indicators)
3. Safe operations (confirmations before destructive actions)
4. Runtime-agnostic (Docker and Podman)

### Runtime Detection

**Automatic Detection:**
```bash
detect_runtime() {
    if command -v docker &> /dev/null; then
        RUNTIME="docker"
        RUNTIME_NAME="Docker"
    elif command -v podman &> /dev/null; then
        RUNTIME="podman"
        RUNTIME_NAME="Podman"
    else
        RUNTIME="none"
        RUNTIME_NAME="None"
    fi
}
```

**Usage:**
```bash
# Works with both Docker and Podman
$RUNTIME ps
$RUNTIME images
$RUNTIME stop container_name
```

### Menu System

**State Management:**
- No persistent state (runs fresh each time)
- Real-time status queries
- Transient operation results

**Color Scheme:**
```bash
GREEN='\033[0;32m'   # Success, running
BLUE='\033[0;34m'    # Information, Docker
YELLOW='\033[1;33m'  # Warnings, notes
RED='\033[0;31m'     # Errors, stopped
CYAN='\033[0;36m'    # Headers
MAGENTA='\033[0;35m' # Podman-specific
NC='\033[0m'         # No Color (reset)
```

### Platform-Specific Behavior

**Docker (Linux):**
```bash
# Start service
sudo systemctl start docker

# Stop service
sudo systemctl stop docker

# Restart
sudo systemctl restart docker
```

**Docker (macOS):**
```bash
# Start
open -a Docker

# Stop
osascript -e 'quit app "Docker"'
```

**Podman (Linux):**
```bash
# No service to start (daemonless)
# Containers start on-demand

# Stop all containers
podman stop -a

# System reset
podman system reset -f
```

### Menu Options Detailed

| Option | Function | Docker Command | Podman Command |
|--------|----------|----------------|----------------|
| 1 | Check Status | `docker info` | `podman info` |
| 2 | Start | `systemctl start docker` | N/A (daemonless) |
| 3 | Stop | `systemctl stop docker` | `podman stop -a` |
| 4 | Restart | `systemctl restart docker` | `podman restart -a` |
| 5 | View Containers | `docker ps` | `podman ps` |
| 6 | All Containers | `docker ps -a` | `podman ps -a` |
| 7 | List Images | `docker images` | `podman images` |
| 8 | Cleanup | `docker system prune` | `podman system prune` |
| 9 | System Info | `docker info` | `podman info` |
| 10 | Test | `docker run hello-world` | `podman run hello-world` |
| 11 | Exit | Exit script | Exit script |

---

## Platform-Specific Details

### Linux Specifics

**Supported Distributions:**
- Ubuntu (all supported versions)
- Debian (Buster, Bullseye, Bookworm)
- Derivatives (Linux Mint, Pop!_OS, etc.)

**Detection Method:**
```bash
lsb_release -a 2>/dev/null | grep -iqE 'Ubuntu|Debian'
```

**Package Dependencies:**
- `curl`: HTTP client
- `lsb_release`: Distribution detection
- `systemctl`: Service management (systemd)

**Docker Daemon Management:**
```bash
# Enable auto-start
sudo systemctl enable docker

# Check status
systemctl status docker

# View logs
journalctl -u docker
```

### macOS Specifics

**Version Detection:**
```bash
MACOS_VERSION=$(sw_vers -productVersion)
MACOS_MAJOR=$(echo "$MACOS_VERSION" | cut -d '.' -f 1)
MACOS_MINOR=$(echo "$MACOS_VERSION" | cut -d '.' -f 2)
```

**Version Validation:**
```bash
# Require 10.14+
if [ "$MACOS_MAJOR" -lt 10 ] || ([ "$MACOS_MAJOR" -eq 10 ] && [ "$MACOS_MINOR" -lt 14 ]); then
    echo "ERROR: Requires macOS 10.14 or newer"
    exit 1
fi
```

**Docker Desktop Specifics:**
- Includes: Docker Engine, CLI, Compose, Kubernetes
- Auto-updates available
- GUI for configuration
- Resource limits configurable

### Windows Specifics

**Edition Requirements:**
- Windows 10 Pro/Enterprise/Education (Hyper-V required)
- Windows 11 Home/Pro/Enterprise/Education (WSL 2)

**WSL 2 Dependency:**
```powershell
# Check if WSL 2 is available
wsl --list --verbose
```

**Installation Arguments:**
```powershell
Start-Process -FilePath "DockerDesktopInstaller.exe" -Args "install" -Wait
```

---

## Troubleshooting

### Common Issues

#### Issue: "Docker daemon is not running"

**Symptoms:**
```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock
```

**Solutions:**

**Linux:**
```bash
sudo systemctl start docker
sudo systemctl enable docker  # Auto-start on boot
```

**macOS:**
```bash
open -a Docker
# Wait 30-60 seconds for startup
```

**Verification:**
```bash
docker info
```

---

#### Issue: "Permission denied" (Linux)

**Symptoms:**
```
Got permission denied while trying to connect to the Docker daemon socket
```

**Solution:**
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Log out and back in (or reboot)

# Verify
groups | grep docker
```

---

#### Issue: GitHub API rate limiting

**Symptoms:**
```
Note: Could not fetch latest version from GitHub API
Using fallback version: v2.24.5
```

**Explanation:**
- GitHub limits unauthenticated API requests to 60/hour
- Not an error - fallback version is recent and functional

**Solution (Optional):**
```bash
# Use authenticated requests (higher limit)
curl -H "Authorization: token YOUR_GITHUB_TOKEN" \
  https://api.github.com/repos/docker/compose/releases/latest
```

---

#### Issue: macOS DMG mount failure

**Symptoms:**
```
ERROR: Failed to mount Docker.dmg
```

**Possible Causes:**
1. Another "Docker" volume already mounted
2. Corrupted download
3. Insufficient disk space

**Solutions:**
```bash
# Unmount existing
hdiutil detach /Volumes/Docker

# Check disk space
df -h

# Re-download
rm ~/Downloads/Docker.dmg
# Run installer again
```

---

#### Issue: Podman alias not working

**Symptoms:**
```bash
docker: command not found
# But podman works
```

**Solution:**
```bash
# Restart terminal or
source ~/.bashrc

# Verify alias
alias docker
# Should show: alias docker='podman'
```

---

### Debug Mode

**Enable verbose output:**

**Bash scripts:**
```bash
bash -x install-docker-linux.sh
```

**PowerShell:**
```powershell
Set-PSDebug -Trace 1
.\install-docker-windows.ps1
```

---

## Advanced Configuration

### Custom Docker Compose Version

**Edit before running:**
```bash
# In install-docker-linux.sh
DOCKER_COMPOSE_VERSION="v2.20.0"  # Specific version
```

### Skip Checksum Verification

**Not recommended, but possible:**
```bash
# Comment out verification block in install-docker-linux.sh
# Lines ~103-127
```

### Podman Rootless Configuration

**Enable after installation:**
```bash
# Allow user namespaces
sudo sysctl -w user.max_user_namespaces=28633

# Make persistent
echo "user.max_user_namespaces=28633" | sudo tee -a /etc/sysctl.conf

# Test rootless
podman run --rm hello-world
```

### Docker Desktop Resource Limits

**macOS/Windows:**
1. Open Docker Desktop
2. Settings → Resources
3. Adjust:
   - CPUs: Number of cores
   - Memory: RAM allocation
   - Swap: Swap file size
   - Disk: Image storage size

---

## Contributing

### Development Setup

**Prerequisites:**
- Bash 4.0+
- PowerShell 5.1+ (for Windows script)
- shellcheck (optional but recommended)

**Clone and setup:**
```bash
git clone https://github.com/shadowdevnotreal/universal-docker.git
cd universal-docker

# Make scripts executable
chmod +x *.sh

# Run shellcheck
shellcheck *.sh
```

### Code Style

**Bash:**
- Use `snake_case` for function names
- 4-space indentation
- Comment complex logic
- Use `set -euo pipefail`
- Quote variables: `"$VARIABLE"`

**PowerShell:**
- Use `PascalCase` for functions
- 4-space indentation
- Comment cmdlet usage
- Use approved verbs (Get-, Set-, New-, etc.)

### Testing

**Manual testing checklist:**
- [ ] Fresh Ubuntu 22.04 VM
- [ ] Fresh macOS 13+ VM
- [ ] Fresh Windows 10/11 VM
- [ ] Existing Docker installation scenario
- [ ] Network failure scenarios
- [ ] Podman installation (Linux)
- [ ] Container Manager on Docker
- [ ] Container Manager on Podman

### Commit Message Format

```
[Component] Brief description

Detailed explanation of changes:
- What was changed
- Why it was changed
- Any breaking changes

Fixes #issue_number
```

**Example:**
```
[install-linux] Add Podman support

Added interactive choice between Docker and Podman during installation.
Includes automatic alias setup for Docker compatibility.

- New function: install_podman()
- Docker compatibility aliases in ~/.bashrc
- podman-compose installation via pip3

Fixes #42
```

### Pull Request Process

1. **Fork** the repository
2. **Create** feature branch: `git checkout -b feature/amazing-feature`
3. **Commit** changes with clear messages
4. **Test** thoroughly on target platforms
5. **Push** to branch: `git push origin feature/amazing-feature`
6. **Open** Pull Request with description
7. **Address** review feedback

**PR Template:**
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tested on Linux
- [ ] Tested on macOS
- [ ] Tested on Windows
- [ ] Existing installations tested

## Checklist
- [ ] Code follows project style
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
```

---

## API Reference

### universal-installer.sh

**Functions:**

```bash
install_linux()
# Purpose: Invoke Linux installer
# Parameters: None
# Returns: Exit code from install-docker-linux.sh

install_mac()
# Purpose: Invoke macOS installer
# Parameters: None
# Returns: Exit code from install-docker-mac.sh
```

**Variables:**

```bash
OS              # Detected operating system (Linux, Mac, UNKNOWN)
```

### install-docker-linux.sh

**Functions:**

```bash
# No exported functions (standalone script)
```

**Variables:**

```bash
DOCKER_COMPOSE_VERSION  # Latest version from GitHub or fallback
INSTALL_PODMAN          # Boolean: true if user chose Podman
EXPECTED_CHECKSUM       # SHA256 hash from GitHub
ACTUAL_CHECKSUM         # SHA256 hash of downloaded file
```

### docker-manager.sh

**Functions:**

```bash
detect_runtime()
# Purpose: Detect Docker or Podman installation
# Sets: RUNTIME, RUNTIME_NAME

check_runtime_installed()
# Purpose: Verify container runtime exists
# Exits if none found

check_docker_status()
# Purpose: Display runtime status and version

start_docker()
# Purpose: Start Docker service or explain Podman is daemonless

stop_docker()
# Purpose: Stop Docker service or stop Podman containers

restart_docker()
# Purpose: Restart Docker or offer Podman system reset

view_containers()
# Purpose: List running containers with interactive options

view_all_containers()
# Purpose: List all containers including stopped

list_images()
# Purpose: Display all images with size info

cleanup_docker()
# Purpose: Interactive cleanup menu

show_system_info()
# Purpose: Display runtime system information

run_test_container()
# Purpose: Run hello-world for verification

show_menu()
# Purpose: Display main menu and handle selection

main()
# Purpose: Main program loop
```

**Variables:**

```bash
RUNTIME         # "docker" or "podman"
RUNTIME_NAME    # "Docker" or "Podman"
PLATFORM        # "Linux" or "Mac"

# Color codes
GREEN, BLUE, YELLOW, RED, CYAN, MAGENTA, NC
```

---

## Performance Considerations

### Installation Time

| Platform | Docker | Podman | Factors |
|----------|--------|--------|---------|
| Linux | 5-10 min | 3-5 min | Internet speed, CPU |
| macOS | 10-15 min | N/A | Download size (~500MB) |
| Windows | 10-20 min | N/A | WSL 2 initialization |

### Resource Usage

**Docker (with daemon):**
- Memory: ~2GB base + containers
- CPU: ~1-2% idle
- Disk: ~4GB for Docker Desktop

**Podman (daemonless):**
- Memory: 0MB idle (only when containers run)
- CPU: 0% idle
- Disk: ~500MB for Podman

---

## Changelog

### v2.0.0 (Container Manager)
- Added Podman support
- Runtime auto-detection
- Platform-specific service management
- Enhanced error messages

### v1.0.0 (Initial Release)
- Cross-platform installation
- Docker Engine for Linux
- Docker Desktop for macOS/Windows
- Basic safety checks
- SHA256 verification (Linux)

---

## Future Roadmap

**Planned Features:**
- [ ] Docker Swarm initialization option
- [ ] Kubernetes cluster setup (kind/k3s)
- [ ] Container image management (pull/tag/push)
- [ ] Docker network management
- [ ] Volume management UI
- [ ] Docker Compose file validator
- [ ] Multi-architecture build support
- [ ] Integration with CI/CD tools

---

## License

MIT License - see [LICENSE](LICENSE) for full text.

**Summary:**
- ✅ Commercial use
- ✅ Modification
- ✅ Distribution
- ✅ Private use
- ℹ️ License and copyright notice required
- ❌ No liability
- ❌ No warranty

---

## References

**Official Documentation:**
- [Docker Docs](https://docs.docker.com/)
- [Podman Docs](https://docs.podman.io/)
- [Docker Compose Docs](https://docs.docker.com/compose/)

**Repositories:**
- [Docker Engine](https://github.com/docker/docker-ce)
- [Docker Compose](https://github.com/docker/compose)
- [Podman](https://github.com/containers/podman)

**Security:**
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
- [Podman Security](https://docs.podman.io/en/latest/markdown/podman-security.1.html)

---

<div align="center">

**Questions? [Open an Issue](https://github.com/shadowdevnotreal/universal-docker/issues)**

[⬆ Back to Top](#universal-docker-installer---technical-wiki)

</div>
