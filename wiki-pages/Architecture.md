# System Architecture

This page details the system architecture and design decisions behind the Universal Docker Installer.

---

## High-Level Flow

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

---

## Linux Installation Flow

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

### Menu Options

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

[⬅ Back to Home](Home)
