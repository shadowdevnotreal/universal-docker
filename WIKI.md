# Universal Docker Installer - Technical Wiki

<div align="center">

**Technical Documentation for Developers and System Administrators**

</div>

---

## Welcome

This wiki provides comprehensive technical documentation for the Universal Docker Installer project. Whether you're a developer looking to contribute, a system administrator deploying the solution, or a user seeking deeper understanding, you'll find detailed information here.

## Quick Navigation

### 📚 Core Documentation
- **[Installation Details](Installation-Details)** - Platform-specific installation processes
- **[Architecture](Architecture)** - System design and component interactions
- **[Security](Security)** - Security implementation and threat model

### 🛠️ Tools & Components
- **[Container Manager](Container-Manager)** - Interactive management tool details
- **[Script Specifications](Script-Specifications)** - Error handling, logging, and conventions

### 🔧 Maintenance & Development
- **[Troubleshooting](Troubleshooting)** - Common issues and solutions
- **[Advanced Configuration](Advanced-Configuration)** - Customization options
- **[Contributing](Contributing)** - Development setup and guidelines
- **[API Reference](API-Reference)** - Function and variable documentation

---

## Project Overview

### Project Structure

```
universal-docker/
├── universal-installer.sh      # Main entry point (Linux/macOS)
├── install-docker-linux.sh     # Linux-specific installer
├── install-docker-mac.sh       # macOS-specific installer
├── install-docker-windows.ps1  # Windows-specific installer
├── docker-manager.sh           # Interactive container management tool (v2.0)
├── README.md                   # User-friendly documentation
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

## License

MIT License - see [LICENSE](https://github.com/shadowdevnotreal/universal-docker/blob/main/LICENSE) for full text.

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

</div>

---


---

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

---

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

---

# Security Implementation

Details about security measures, threat model, and verification processes.

---

## Threat Model

### Protected Against

- ✅ **Corrupted downloads** - SHA256 verification
- ✅ **Man-in-the-middle attacks** - HTTPS + checksums
- ✅ **Accidental overwrites** - Existing installation detection
- ✅ **Privilege escalation** - Explicit sudo prompts
- ✅ **Untrusted sources** - Official repositories only

### NOT Protected Against

- ❌ **Compromised official repositories** - Beyond our control
- ❌ **Local system compromise** - If already rooted
- ❌ **Social engineering attacks** - User responsibility

---

## Checksum Verification

### Docker Compose Only (Linux)

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

### Why Docker Engine Not Verified

- Docker's official `get.docker.sh` handles GPG verification
- Package manager (apt/yum) verifies signatures
- We delegate to official, trusted mechanisms

---

## HTTPS Enforcement

All downloads use HTTPS:
- `curl -fsSL https://...`
- Enforced SSL certificate validation
- No HTTP fallback

---

## Privilege Management

### Principle of Least Privilege

Scripts run as regular user, with `sudo` only when necessary:
- Package installation
- System file modifications
- Service management

### User Awareness

```bash
if ! sudo -n true 2>/dev/null; then
    echo "This script requires sudo privileges."
    echo "You may be prompted for your password."
fi
```

---

## Best Practices

### For Users

1. **Always verify the script source** before running
2. **Read the script** if you have concerns
3. **Run on test systems first** before production
4. **Keep Docker/Podman updated** after installation
5. **Use rootless containers** when possible (Podman)

### For Developers

1. **Never disable verification** in production scripts
2. **Always use HTTPS** for downloads
3. **Prompt for sudo** explicitly, never assume
4. **Handle checksum failures** gracefully
5. **Document security decisions** in code comments

---

## Security Resources

**Docker Security:**
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)

**Podman Security:**
- [Podman Security Guide](https://docs.podman.io/en/latest/markdown/podman-security.1.html)
- [Rootless Containers](https://rootlesscontaine.rs/)

**General:**
- [OWASP Container Security](https://owasp.org/www-project-docker-top-10/)

---

[⬅ Back to Home](Home)

---

# Script Specifications

Technical specifications for error handling, logging, and coding conventions.

---

## Error Handling

All Bash scripts use:
```bash
set -euo pipefail
```

**Meaning:**
- `set -e`: Exit immediately if any command fails
- `set -u`: Treat unset variables as errors
- `set -o pipefail`: Pipe failures propagate

**Example:**
```bash
#!/bin/bash
set -euo pipefail

# This will exit if curl fails
curl -fsSL https://example.com/file.sh | sh

# This will exit if MYVAR is unset
echo "$MYVAR"

# This will exit if grep fails in the pipe
cat file.txt | grep "pattern" | wc -l
```

---

## Logging

### Output Levels

- ✓ **Success indicators** (green checkmarks)
- ⚠️ **Warnings** (yellow text)
- ❌ **Errors** (red text)
- ℹ️ **Information** (blue text)

**Example:**
```bash
echo "✓ Docker Engine installed"
echo "WARNING: Could not verify checksum"
echo "ERROR: Failed to download"
```

### Color Codes

```bash
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'  # No Color (reset)
```

**Usage:**
```bash
echo -e "${GREEN}✓ Success${NC}"
echo -e "${YELLOW}⚠ Warning${NC}"
echo -e "${RED}❌ Error${NC}"
```

---

## User Interactions

### Confirmation Prompts

```bash
read -p "Do you want to continue? (y/n): " response
case $response in
    [Yy]*) proceed ;;
    *) abort ;;
esac
```

### Pause Points

```bash
read -p "Press Enter to continue or Ctrl+C to cancel..."
```

### Choice Menus

```bash
echo "Choose your option:"
echo "  1. Option One"
echo "  2. Option Two"
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1) option_one ;;
    2) option_two ;;
    *) echo "Invalid choice" ;;
esac
```

---

## Code Style

### Bash

- **Naming:** Use `snake_case` for function names
- **Indentation:** 4 spaces
- **Comments:** Explain complex logic
- **Error handling:** Always use `set -euo pipefail`
- **Variables:** Always quote: `"$VARIABLE"`

**Example:**
```bash
#!/bin/bash
set -euo pipefail

# Function to install Docker
install_docker() {
    local DOCKER_VERSION="$1"

    echo "Installing Docker ${DOCKER_VERSION}..."

    # Download and execute installation script
    curl -fsSL https://get.docker.com | sh

    echo "✓ Docker installed successfully"
}

# Main execution
install_docker "latest"
```

### PowerShell

- **Naming:** Use `PascalCase` for functions
- **Indentation:** 4 spaces
- **Comments:** Explain cmdlet usage
- **Verbs:** Use approved verbs (Get-, Set-, New-, etc.)

**Example:**
```powershell
function Install-Docker {
    param (
        [string]$Version = "latest"
    )

    Write-Host "Installing Docker $Version..." -ForegroundColor Cyan

    # Download installer
    $installerPath = "$env:USERPROFILE\Downloads\DockerDesktopInstaller.exe"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath

    Write-Host "✓ Docker installer downloaded" -ForegroundColor Green
}

# Main execution
Install-Docker
```

---

## Testing Conventions

### Manual Testing Checklist

- [ ] Fresh Ubuntu 22.04 VM
- [ ] Fresh macOS 13+ VM
- [ ] Fresh Windows 10/11 VM
- [ ] Existing Docker installation scenario
- [ ] Network failure scenarios
- [ ] Podman installation (Linux)
- [ ] Container Manager on Docker
- [ ] Container Manager on Podman

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

[⬅ Back to Home](Home)

---

# Docker Packager

Interactive tool for packaging applications into Docker/Podman containers with zero Docker knowledge required.

---

## Overview

**docker-packager.sh** is an interactive tool that helps users create production-ready Dockerfiles, .dockerignore files, and docker-compose.yml configurations with best practices built-in.

### Key Features

✅ **Auto-detection** - Identifies project type automatically
✅ **Multi-stage builds** - Creates optimized, small images
✅ **Non-root users** - Secure by default (UID 1001)
✅ **Health checks** - Automatic container monitoring
✅ **Runtime agnostic** - Works with Docker, Podman, and Buildah
✅ **Prerequisites checking** - Validates all dependencies before running

---

## Quick Start

### Basic Usage

```bash
# Navigate to your project directory
cd my-project

# Run the packager
./docker-packager.sh

# Follow the interactive prompts
```

### Example Session

```
╔════════════════════════════════════════════════════════════╗
║         🐳 Docker/Podman Application Packager           ║
║                     Version 1.0.0                        ║
╚════════════════════════════════════════════════════════════╝

Runtime: Docker
Build Tool: Docker

══════════════════════════════════════════════════════════════
  What would you like to do?
══════════════════════════════════════════════════════════════

  1. 📦 Create Dockerfile (Interactive)
  2. 🏗️  Build & Test Container
  3. 📝 Generate Docker Compose
  4. ℹ️  Show Project Info
  5. ❌ Exit
```

---

## Supported Project Types

### Node.js

**Detection:** `package.json`

**Generated Dockerfile:**
- Multi-stage build
- Alpine Linux base (small size)
- `npm ci` for production dependencies
- Non-root user (appuser)
- Health check on exposed port
- Layer caching optimization

**Example:**
```dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .

FROM node:18-alpine
RUN addgroup -g 1001 appuser && \
    adduser -D -u 1001 -G appuser appuser
WORKDIR /app
COPY --from=builder --chown=appuser:appuser /app ./
USER appuser
EXPOSE 3000
HEALTHCHECK CMD node -e "require('http').get(...)"
CMD npm start
```

### Python

**Detection:** `requirements.txt`, `pyproject.toml`, or `setup.py`

**Generated Dockerfile:**
- Multi-stage build
- Python slim base
- pip install with --user flag
- Non-root user (appuser)
- Virtual environment support
- Health check

**Example:**
```dockerfile
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

FROM python:3.11-slim
RUN useradd -m -u 1001 appuser
WORKDIR /app
COPY --from=builder --chown=appuser:appuser /root/.local /home/appuser/.local
COPY --chown=appuser:appuser . .
ENV PATH=/home/appuser/.local/bin:$PATH
USER appuser
EXPOSE 8000
HEALTHCHECK CMD python -c "import urllib.request..."
CMD python app.py
```

### Go

**Detection:** `go.mod` or `go.sum`

**Generated Dockerfile:**
- Multi-stage build
- CGO_ENABLED=0 for static binary
- Alpine Linux (minimal size)
- Non-root user
- Health check with wget

**Example:**
```dockerfile
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o app .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
RUN addgroup -g 1001 appuser && \
    adduser -D -u 1001 -G appuser appuser
WORKDIR /app
COPY --from=builder --chown=appuser:appuser /app/app ./
USER appuser
EXPOSE 8080
HEALTHCHECK CMD wget --spider http://localhost:8080/ || exit 1
CMD ["./app"]
```

### Static Sites

**Detection:** `index.html` (without package.json)

**Generated Dockerfile:**
- nginx:alpine base
- Simple static file serving
- Health check

**Example:**
```dockerfile
FROM nginx:alpine
COPY . /usr/share/nginx/html
EXPOSE 80
HEALTHCHECK CMD wget --spider http://localhost/ || exit 1
```

---

## Menu Options

### Option 1: Create Dockerfile

**Interactive Flow:**

1. **Project Detection**
   - Auto-detects project type
   - Confirms with user
   - Allows manual selection if detection fails

2. **Configuration Questions**
   - Port number (with sensible defaults)
   - Entry command
   - Environment variables (optional)

3. **File Generation**
   - Creates `Dockerfile`
   - Creates `.dockerignore`
   - Checks for existing files (asks to overwrite)

4. **Output**
   - Success message
   - Next steps suggestion

**Generated Files:**

**.dockerignore** (language-specific):
```
# Node.js
node_modules
npm-debug.log
.git
.env
*.log
coverage
dist
build

# Python
__pycache__
*.pyc
venv/
.pytest_cache

# Go
vendor/
bin/
*.exe
*.test
```

### Option 2: Build & Test Container

**Flow:**

1. **Validation**
   - Checks for Dockerfile existence
   - Prompts to create if missing

2. **Image Naming**
   - Suggests name from directory
   - Asks for tag (default: latest)

3. **Build Process**
   - Uses detected runtime (Docker/Podman/Buildah)
   - Shows build output
   - Reports success/failure

4. **Test Run** (optional)
   - Asks to run container
   - Prompts for port mapping
   - Runs with `--rm` flag (auto-cleanup)
   - Shows logs in real-time

**Example:**
```bash
Image name? [my-app]:
Image tag? [latest]:

🏗️  Building image: my-app:latest

Using Docker for build...
✅ Image built successfully!

Would you like to test run the container? (y/n): y

Map to host port? (leave empty to skip): 3000
Container port? [3000]:

🚀 Running container...

Command: docker run --rm --name my-app-test -p 3000:3000 my-app:latest
Press Ctrl+C to stop the container

Server running at http://localhost:3000/
```

### Option 3: Generate Docker Compose

**Flow:**

1. **Prerequisites Check**
   - Verifies docker-compose/podman-compose installed
   - Offers to continue anyway if missing
   - Shows installation instructions

2. **Configuration**
   - Service name
   - Port mapping
   - Additional services selection:
     - PostgreSQL
     - Redis
     - MongoDB

3. **File Generation**
   - Creates `docker-compose.yml`
   - Configures networks
   - Sets up volumes
   - Includes environment variables

**Generated docker-compose.yml:**
```yaml
version: '3.8'

services:
  myapp:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    depends_on:
      - postgres
      - redis
    networks:
      - app-network

  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: app_db
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - app-network
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    networks:
      - app-network
    ports:
      - "6379:6379"

networks:
  app-network:
    driver: bridge

volumes:
  postgres-data:
```

### Option 4: Show Project Info

**Displays:**
- Project type (detected)
- Current directory
- Container runtime
- Build tool
- List of files in directory

**Example:**
```
══════════════════════════════════════════════════════════════
  Project Information
══════════════════════════════════════════════════════════════

📁 Detecting project type...
   ✓ Detected: Node.js (found package.json)

Project Type: nodejs
Current Directory: /home/user/my-project
Container Runtime: Docker
Build Tool: Docker

Files in current directory:
drwxr-xr-x  5 user user  160 Nov 19 12:00 .
drwxr-xr-x 10 user user  320 Nov 19 11:00 ..
-rw-r--r--  1 user user  500 Nov 19 12:00 package.json
-rw-r--r--  1 user user 1200 Nov 19 12:00 index.js
drwxr-xr-x  3 user user   96 Nov 19 11:00 node_modules
```

---

## Prerequisites

### Required Dependencies

The packager automatically checks for and reports missing dependencies:

**Critical (script won't run without these):**
- `bash` - Shell interpreter
- `sed` - Text stream editor
- `grep` - Pattern matching
- `awk` - Text processing
- `basename` - Extract filename from path
- `pwd` - Print working directory

**Runtime (at least one required):**
- Docker
- Podman
- Buildah (optional, for Podman builds)

**Optional (for specific features):**
- `docker-compose` or `podman-compose` - For Option 3 (Generate Compose)

### Installation Instructions

If dependencies are missing, the tool shows:

**Ubuntu/Debian:**
```bash
sudo apt-get install sed grep gawk coreutils
```

**macOS:**
```bash
brew install coreutils
```

**Docker Compose:**
```bash
# For Docker
sudo apt-get install docker-compose

# For Podman
pip3 install podman-compose
```

---

## Runtime Detection

The packager supports multiple container runtimes and automatically adapts.

### Detection Logic

```bash
detect_runtime() {
    if command -v docker &> /dev/null; then
        RUNTIME="docker"
        BUILD_TOOL="docker"
    elif command -v podman &> /dev/null; then
        RUNTIME="podman"
        if command -v buildah &> /dev/null; then
            BUILD_TOOL="buildah"  # Preferred for Podman
        else
            BUILD_TOOL="podman"
        fi
    else
        RUNTIME="none"
    fi
}
```

### Build Commands

| Runtime | Build Command | Run Command |
|---------|---------------|-------------|
| Docker | `docker build -t IMAGE .` | `docker run --rm -p PORT:PORT IMAGE` |
| Podman | `podman build -t IMAGE .` | `podman run --rm -p PORT:PORT IMAGE` |
| Buildah | `buildah bud -t IMAGE .` | (uses podman for run) |

---

## Best Practices Implemented

### 1. Multi-Stage Builds

**Benefit:** 50-80% smaller images

**Pattern:**
```dockerfile
# Build stage - contains build tools
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Production stage - minimal dependencies
FROM node:18-alpine
COPY --from=builder /app ./
```

### 2. Non-Root Users

**Benefit:** Security, compliance

**Implementation:**
```dockerfile
# Alpine Linux (Node.js, Go)
RUN addgroup -g 1001 appuser && \
    adduser -D -u 1001 -G appuser appuser

# Debian/Ubuntu (Python)
RUN useradd -m -u 1001 appuser

USER appuser
```

### 3. Health Checks

**Benefit:** Container orchestration, automatic restart

**Patterns:**
```dockerfile
# HTTP check (Node.js)
HEALTHCHECK CMD node -e "require('http').get('http://localhost:3000/', ...)"

# HTTP check (Python)
HEALTHCHECK CMD python -c "import urllib.request; ..."

# HTTP check (Go, Static)
HEALTHCHECK CMD wget --spider http://localhost:8080/ || exit 1
```

### 4. Layer Caching

**Benefit:** Faster rebuilds

**Order:**
1. Dependency files (changes rarely)
2. Install dependencies
3. Source code (changes frequently)
4. Build application

### 5. .dockerignore

**Benefit:** Smaller build context, faster builds, no secrets leaked

**Critical patterns:**
- `.git/`
- `.env`
- `node_modules/` (for Node.js)
- `__pycache__/` (for Python)
- `*.log`

---

## Error Handling

### No Runtime Found

```
❌ Error: No container runtime found!

Please install Docker or Podman first:
  • Run: ./universal-installer.sh
  • Or visit: https://github.com/shadowdevnotreal/universal-docker
```

### Missing Dependencies

```
❌ Missing required dependencies:
  • sed
  • grep

Please install missing dependencies using your package manager:
  • Ubuntu/Debian: sudo apt-get install sed grep
  • macOS: brew install coreutils
```

### No Dockerfile for Build

```
❌ No Dockerfile found in current directory

Please create a Dockerfile first (Option 1)
```

### Compose Not Available

```
⚠️  docker-compose/podman-compose not found

To use this feature, install:
  • Docker Compose: sudo apt-get install docker-compose
  • Or use Docker Compose v2: already bundled with Docker Desktop

You can still create docker-compose.yml manually, but you won't be able to run it.

Continue anyway? (y/n):
```

---

## Advanced Usage

### Custom Port Mapping

When testing containers, you can map any host port to container port:

```
Map to host port? [leave empty to skip]: 8080
Container port? [3000]: 3000
```

This allows running multiple containers simultaneously without port conflicts.

### Environment Variables

While the base Dockerfile includes common environment variables, you can customize them at runtime:

```bash
docker run -e NODE_ENV=development -e DEBUG=true myapp:latest
```

Or in docker-compose.yml:
```yaml
services:
  myapp:
    environment:
      - NODE_ENV=development
      - DEBUG=true
      - DATABASE_URL=postgres://...
```

### Multi-Container Development

Use docker-compose for full development environments:

```bash
# Generate compose file with all services
./docker-packager.sh
# Select Option 3
# Choose PostgreSQL, Redis

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

---

## Troubleshooting

### Build Fails

**Check:**
1. Dockerfile syntax is valid
2. All files referenced by COPY exist
3. Sufficient disk space
4. Internet connection (for pulling base images)

**Debug:**
```bash
# Build with verbose output
docker build -t myapp:latest --progress=plain .
```

### Container Exits Immediately

**Check:**
1. CMD/ENTRYPOINT is correct
2. Application doesn't have errors
3. Required files are present

**Debug:**
```bash
# Run interactively
docker run -it myapp:latest /bin/sh

# View logs
docker logs myapp-test
```

### Permission Denied

**Cause:** Non-root user can't access files

**Fix:** Ensure COPY uses --chown:
```dockerfile
COPY --chown=appuser:appuser . .
```

---

## Version History

### v1.0.0 (2025-11-19)

**Features:**
- Interactive Dockerfile generation
- Multi-stage builds for Node.js, Python, Go
- Static site support (nginx)
- .dockerignore generation
- Docker Compose generation
- Build and test workflow
- Runtime detection (Docker/Podman/Buildah)
- Prerequisites checking
- Non-root users by default
- Health checks
- Layer optimization

**Languages Supported:**
- Node.js
- Python
- Go
- Static HTML/CSS/JS

**Stats:**
- 969 lines of code
- 17 functions
- Multi-agent COT methodology

---

## Future Roadmap (v2.0)

**Planned Features:**
- Java support (Spring Boot, Maven/Gradle)
- PHP support (Composer, Laravel)
- Ruby support (Bundler, Rails)
- Framework detection (Express, Django, Gin)
- Registry push functionality
- Integration with docker-manager.sh
- Environment variable templates
- Kubernetes YAML generation
- Multi-architecture builds
- Security scanning integration

---

[⬅ Back to Home](Home)

---

# Troubleshooting

Common issues and their solutions.

---

## Docker Daemon Issues

### Issue: "Docker daemon is not running"

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

## Permission Issues

### Issue: "Permission denied" (Linux)

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

**Alternative (temporary):**
```bash
# Use sudo for individual commands
sudo docker ps
```

---

## API Rate Limiting

### Issue: GitHub API rate limiting

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

## macOS Installation Issues

### Issue: DMG mount failure

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

### Issue: macOS version too old

**Symptoms:**
```
ERROR: This script requires macOS 10.14 (Mojave) or newer
```

**Solution:**
- Upgrade macOS to 10.14 or newer
- Or use Docker Toolbox (legacy, not recommended)

---

## Linux-Specific Issues

### Issue: Podman alias not working

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

### Issue: systemctl not found

**Symptoms:**
```
systemctl: command not found
```

**Explanation:**
- System doesn't use systemd
- May be using init.d, upstart, or another init system

**Solution:**
```bash
# Check init system
ps -p 1

# For init.d
sudo service docker start

# For upstart
sudo start docker
```

---

## Windows-Specific Issues

### Issue: WSL 2 not enabled

**Symptoms:**
```
WSL 2 installation is incomplete
```

**Solution:**
```powershell
# Enable WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Enable Virtual Machine Platform
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Restart computer
# Set WSL 2 as default
wsl --set-default-version 2
```

### Issue: Virtualization not enabled

**Symptoms:**
```
Hardware assisted virtualization and data execution protection must be enabled in the BIOS
```

**Solution:**
1. Restart computer
2. Enter BIOS/UEFI (usually F2, F10, Del, or Esc during boot)
3. Find "Virtualization Technology" or "Intel VT-x" or "AMD-V"
4. Enable it
5. Save and exit

---

## Container Issues

### Issue: Cannot pull images

**Symptoms:**
```
Error response from daemon: Get https://registry-1.docker.io/v2/: dial tcp: lookup registry-1.docker.io: no such host
```

**Solutions:**
```bash
# Check internet connection
ping 8.8.8.8

# Check DNS resolution
nslookup registry-1.docker.io

# Try different DNS (Google DNS)
# Add to /etc/docker/daemon.json:
{
  "dns": ["8.8.8.8", "8.8.4.4"]
}

# Restart Docker
sudo systemctl restart docker
```

### Issue: Container exits immediately

**Symptoms:**
```bash
docker run myimage
# Container exits with code 0 or 1
```

**Troubleshooting:**
```bash
# View logs
docker logs <container_name>

# Run interactively
docker run -it myimage /bin/bash

# Check exit code
docker ps -a
# Look at STATUS column
```

---

## Diagnostic Commands

### Check Docker Installation

```bash
# Version info
docker --version
docker-compose --version

# System info
docker info

# Test run
docker run hello-world
```

### Check Podman Installation

```bash
# Version info
podman --version
podman-compose --version

# System info
podman info

# Test run
podman run hello-world
```

### System Resources

```bash
# Disk usage
docker system df
# or
podman system df

# Clean up
docker system prune
# or
podman system prune
```

---

## Getting Help

If your issue isn't covered here:

1. **Check logs:**
   - Linux: `journalctl -u docker`
   - macOS: Docker Desktop → Troubleshoot → Show logs
   - Windows: Docker Desktop → Troubleshoot → Show logs

2. **Search existing issues:**
   - [Docker GitHub Issues](https://github.com/docker/docker-ce/issues)
   - [Podman GitHub Issues](https://github.com/containers/podman/issues)
   - [Our Issues](https://github.com/shadowdevnotreal/universal-docker/issues)

3. **Create new issue:**
   - Include OS version
   - Include error messages
   - Include relevant logs
   - Describe steps to reproduce

---

[⬅ Back to Home](Home)

---

# Advanced Configuration

Customization options and advanced settings.

---

## Custom Docker Compose Version

### Specify Exact Version

**Edit before running:**
```bash
# In install-docker-linux.sh
DOCKER_COMPOSE_VERSION="v2.20.0"  # Specific version
```

### Skip Version Detection

**Force a specific version:**
```bash
# Comment out GitHub API call
# Use hardcoded version
DOCKER_COMPOSE_VERSION="v2.24.5"
```

---

## Checksum Verification

### Skip Verification (Not Recommended)

**If absolutely necessary:**
```bash
# Comment out verification block in install-docker-linux.sh
# Lines containing SHA256 verification
```

**Warning:** This reduces security. Only do this if:
- You're in a trusted environment
- GitHub is blocking your requests
- You understand the risks

---

## Podman Configuration

### Rootless Mode

**Enable after installation:**
```bash
# Allow user namespaces
sudo sysctl -w user.max_user_namespaces=28633

# Make persistent
echo "user.max_user_namespaces=28633" | sudo tee -a /etc/sysctl.conf

# Test rootless
podman run --rm hello-world
```

### Storage Configuration

**Edit storage config:**
```bash
# Edit ~/.config/containers/storage.conf
mkdir -p ~/.config/containers

cat > ~/.config/containers/storage.conf << EOF
[storage]
driver = "overlay"
runroot = "/run/user/$(id -u)/containers"
graphroot = "$HOME/.local/share/containers/storage"

[storage.options.overlay]
mountopt = "nodev"
EOF
```

### Registry Configuration

**Add custom registries:**
```bash
# Edit ~/.config/containers/registries.conf
mkdir -p ~/.config/containers

cat > ~/.config/containers/registries.conf << EOF
[registries.search]
registries = ['docker.io', 'quay.io', 'your-registry.com']

[registries.insecure]
registries = ['localhost:5000']
EOF
```

---

## Docker Configuration

### Daemon Settings

**Edit `/etc/docker/daemon.json`:**
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "dns": ["8.8.8.8", "8.8.4.4"],
  "storage-driver": "overlay2"
}
```

**Apply changes:**
```bash
sudo systemctl restart docker
```

### Default Resource Limits

**Add to daemon.json:**
```json
{
  "default-ulimits": {
    "nofile": {
      "Name": "nofile",
      "Hard": 64000,
      "Soft": 64000
    }
  }
}
```

---

## Docker Desktop Configuration

### Resource Limits (macOS/Windows)

**Via GUI:**
1. Open Docker Desktop
2. Settings → Resources
3. Adjust:
   - **CPUs:** Number of cores (default: 2)
   - **Memory:** RAM allocation (default: 2GB)
   - **Swap:** Swap file size (default: 1GB)
   - **Disk:** Image storage size (default: 64GB)

**Recommended for development:**
- CPUs: Half of available cores
- Memory: 4-8GB
- Swap: 2GB

### Network Settings

**Via GUI:**
1. Docker Desktop → Settings → Resources → Network
2. Configure:
   - Subnet
   - Subnet mask
   - Gateway

**Or edit daemon.json:**
```json
{
  "bip": "192.168.1.1/24",
  "default-address-pools": [
    {
      "base": "192.168.2.0/16",
      "size": 24
    }
  ]
}
```

---

## Container Manager Customization

### Change Default Colors

**Edit docker-manager.sh:**
```bash
# Find color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'

# Change to your preference
# Example: Bright green
GREEN='\033[1;32m'
```

### Add Custom Menu Options

**Example: Add "View Logs" option:**

```bash
# Add to show_menu() function
echo "  12. View container logs"

# Add to case statement
12)
    read -p "Enter container name: " container_name
    $RUNTIME logs "$container_name"
    read -p "Press Enter to continue..."
    ;;
```

### Disable Confirmations

**For experienced users:**
```bash
# Find confirmation prompts
read -p "Are you sure? (y/n): " confirm

# Comment out or skip:
# confirm="y"  # Auto-confirm
```

---

## Proxy Configuration

### HTTP/HTTPS Proxy

**For Docker daemon:**
```bash
# Create systemd drop-in
sudo mkdir -p /etc/systemd/system/docker.service.d

# Create proxy config
sudo cat > /etc/systemd/system/docker.service.d/http-proxy.conf << EOF
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:80"
Environment="HTTPS_PROXY=https://proxy.example.com:443"
Environment="NO_PROXY=localhost,127.0.0.1"
EOF

# Reload and restart
sudo systemctl daemon-reload
sudo systemctl restart docker
```

**For containers:**
```bash
docker run -e HTTP_PROXY=http://proxy.example.com:80 \
           -e HTTPS_PROXY=https://proxy.example.com:443 \
           myimage
```

---

## Logging Configuration

### Change Log Driver

**Available drivers:**
- `json-file` (default)
- `syslog`
- `journald`
- `gelf`
- `fluentd`

**Configure in daemon.json:**
```json
{
  "log-driver": "journald",
  "log-opts": {
    "tag": "docker/{{.Name}}"
  }
}
```

### Centralized Logging

**Example: Send to syslog:**
```json
{
  "log-driver": "syslog",
  "log-opts": {
    "syslog-address": "tcp://192.168.0.42:514",
    "tag": "docker/{{.Name}}"
  }
}
```

---

## Performance Tuning

### Disk Performance

**Use overlay2 storage driver:**
```json
{
  "storage-driver": "overlay2"
}
```

### Network Performance

**Increase MTU:**
```json
{
  "mtu": 1500
}
```

### Build Performance

**Enable BuildKit:**
```bash
export DOCKER_BUILDKIT=1
docker build .
```

**Or set in daemon.json:**
```json
{
  "features": {
    "buildkit": true
  }
}
```

---

## Security Hardening

### Enable User Namespace Remapping

```json
{
  "userns-remap": "default"
}
```

### Disable Legacy Registry

```json
{
  "disable-legacy-registry": true
}
```

### Enable Content Trust

```bash
export DOCKER_CONTENT_TRUST=1
docker pull image:tag
```

---

[⬅ Back to Home](Home)

---

# Contributing

Guidelines for contributing to the Universal Docker Installer project.

---

## Development Setup

### Prerequisites

- **Bash 4.0+** for shell scripts
- **PowerShell 5.1+** for Windows script
- **shellcheck** (optional but recommended) for linting
- **Git** for version control

### Clone and Setup

```bash
git clone https://github.com/shadowdevnotreal/universal-docker.git
cd universal-docker

# Make scripts executable
chmod +x *.sh

# Run shellcheck (if available)
shellcheck *.sh
```

---

## Code Style

### Bash Scripts

**Conventions:**
- Use `snake_case` for function names
- 4-space indentation
- Comment complex logic
- Use `set -euo pipefail`
- Quote variables: `"$VARIABLE"`
- Use descriptive variable names

**Example:**
```bash
#!/bin/bash
set -euo pipefail

# Function to install Docker
install_docker() {
    local DOCKER_VERSION="$1"

    echo "Installing Docker ${DOCKER_VERSION}..."

    # Download and execute installation script
    curl -fsSL https://get.docker.com | sh

    echo "✓ Docker installed successfully"
}

# Main execution
install_docker "latest"
```

### PowerShell Scripts

**Conventions:**
- Use `PascalCase` for functions
- 4-space indentation
- Comment cmdlet usage
- Use approved verbs (Get-, Set-, New-, etc.)
- Use parameter validation

**Example:**
```powershell
function Install-Docker {
    param (
        [Parameter(Mandatory=$false)]
        [string]$Version = "latest"
    )

    Write-Host "Installing Docker $Version..." -ForegroundColor Cyan

    # Download installer
    $installerPath = "$env:USERPROFILE\Downloads\DockerDesktopInstaller.exe"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath

    Write-Host "✓ Docker installer downloaded" -ForegroundColor Green
}

# Main execution
Install-Docker
```

---

## Testing

### Manual Testing Checklist

Before submitting a pull request, test on:

- [ ] **Fresh Ubuntu 22.04 VM**
- [ ] **Fresh macOS 13+ VM** (Intel and Apple Silicon if possible)
- [ ] **Fresh Windows 10/11 VM**
- [ ] **System with existing Docker installation**
- [ ] **Network failure scenarios** (unplug network during install)
- [ ] **Podman installation** (Linux)
- [ ] **Container Manager with Docker**
- [ ] **Container Manager with Podman**

### Test Cases

**Installation:**
- Fresh installation
- Upgrade existing installation
- Installation with network interruption
- Installation on slow network

**Container Manager:**
- All menu options
- Docker and Podman modes
- Error handling (e.g., no containers)
- Platform-specific commands

### Debug Mode

**Enable verbose output:**

**Bash:**
```bash
bash -x install-docker-linux.sh
```

**PowerShell:**
```powershell
Set-PSDebug -Trace 1
.\install-docker-windows.ps1
```

---

## Commit Message Format

Use clear, descriptive commit messages:

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

Changes:
- New function: install_podman()
- Docker compatibility aliases in ~/.bashrc
- podman-compose installation via pip3

Fixes #42
```

**Component prefixes:**
- `[install-linux]` - Linux installer
- `[install-mac]` - macOS installer
- `[install-windows]` - Windows installer
- `[manager]` - Container manager
- `[docs]` - Documentation
- `[security]` - Security-related changes

---

## Pull Request Process

### Steps

1. **Fork** the repository
2. **Create** feature branch: `git checkout -b feature/amazing-feature`
3. **Commit** changes with clear messages
4. **Test** thoroughly on target platforms
5. **Push** to branch: `git push origin feature/amazing-feature`
6. **Open** Pull Request with description
7. **Address** review feedback

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix (non-breaking change fixing an issue)
- [ ] New feature (non-breaking change adding functionality)
- [ ] Breaking change (fix or feature causing existing functionality to change)
- [ ] Documentation update

## Testing
- [ ] Tested on Linux (Ubuntu/Debian)
- [ ] Tested on macOS
- [ ] Tested on Windows
- [ ] Tested with existing installations
- [ ] Tested error scenarios

## Checklist
- [ ] Code follows project style guidelines
- [ ] Comments added for complex logic
- [ ] Documentation updated (README, Wiki, etc.)
- [ ] No breaking changes (or documented if necessary)
- [ ] All tests pass
```

---

## Development Philosophy

### Code With Purpose

**Principles:**
1. **Keep it lean** - Don't add unnecessary features
2. **User responsibility** - Put appropriate responsibility on users
3. **Fail fast** - Use `set -euo pipefail` for early error detection
4. **Clear feedback** - Provide helpful error messages
5. **Security first** - Always verify downloads when possible

**What to avoid:**
- "Go get some coffee" scripts (overly automated)
- Excessive hand-holding
- Unnecessary abstractions
- Feature creep

### When to Add Features

**Add features if they:**
- Solve a common problem
- Improve security
- Enhance clarity for beginners
- Fix platform-specific issues

**Don't add features if they:**
- Only benefit edge cases
- Complicate the codebase
- Duplicate existing functionality
- Require excessive maintenance

---

## Code Review Guidelines

### For Reviewers

**Check for:**
- [ ] Code follows style guidelines
- [ ] Error handling is appropriate
- [ ] Security implications are considered
- [ ] Documentation is updated
- [ ] Commit messages are clear
- [ ] Tests are included/updated

**Provide feedback:**
- Be constructive and specific
- Suggest improvements, don't just criticize
- Explain the "why" behind suggestions
- Acknowledge good practices

### For Contributors

**When receiving feedback:**
- Be open to suggestions
- Ask questions if unclear
- Make requested changes promptly
- Thank reviewers for their time

---

## Issue Reporting

### Bug Reports

**Include:**
- OS and version
- Docker/Podman version (if applicable)
- Exact error message
- Steps to reproduce
- Expected vs actual behavior

**Example:**
```markdown
**Environment:**
- OS: Ubuntu 22.04 LTS
- Script: install-docker-linux.sh
- Version: v1.0.0

**Steps to reproduce:**
1. Run ./install-docker-linux.sh
2. Choose option 1 (Docker Engine)
3. Wait for Docker Compose installation

**Expected:** SHA256 verification passes
**Actual:** Verification fails with "checksum mismatch"

**Error message:**
```
WARNING: Checksum mismatch!
Expected: abc123...
Actual: def456...
```
```

### Feature Requests

**Include:**
- Clear description of feature
- Use case / problem it solves
- Suggested implementation (optional)
- Alternatives considered

---

## Documentation

### When to Update Documentation

**Update docs when:**
- Adding new features
- Changing existing behavior
- Fixing bugs with user-visible impact
- Adding configuration options

**Which docs to update:**
- **README.md** - For user-facing changes
- **Wiki** - For technical details
- **TODO.md** - For roadmap changes
- **Code comments** - For implementation details

### Documentation Style

**README:**
- Simple language
- Examples and screenshots
- FAQs for common questions
- Links to Wiki for details

**Wiki:**
- Technical accuracy
- Code examples
- Architecture diagrams
- Troubleshooting steps

---

## Getting Help

**Resources:**
- [GitHub Issues](https://github.com/shadowdevnotreal/universal-docker/issues)
- [GitHub Discussions](https://github.com/shadowdevnotreal/universal-docker/discussions)
- [Docker Documentation](https://docs.docker.com/)
- [Podman Documentation](https://docs.podman.io/)

**Before asking:**
1. Search existing issues
2. Check documentation
3. Try debugging yourself
4. Prepare a minimal reproducible example

---

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

[⬅ Back to Home](Home)

---

# API Reference

Function and variable reference for all scripts.

---

## universal-installer.sh

### Functions

```bash
install_linux()
# Purpose: Invoke Linux installer
# Parameters: None
# Returns: Exit code from install-docker-linux.sh
# Usage: install_linux

install_mac()
# Purpose: Invoke macOS installer
# Parameters: None
# Returns: Exit code from install-docker-mac.sh
# Usage: install_mac
```

### Variables

```bash
OS
# Type: String
# Values: "Linux", "Mac", "UNKNOWN:${uname_output}"
# Description: Detected operating system
```

---

## install-docker-linux.sh

### Functions

No exported functions (standalone script)

### Variables

```bash
DOCKER_COMPOSE_VERSION
# Type: String
# Example: "v2.24.5"
# Description: Docker Compose version to install
# Source: GitHub API or fallback

INSTALL_PODMAN
# Type: Boolean (true/false)
# Description: Whether user chose Podman installation

EXPECTED_CHECKSUM
# Type: String (64 hex chars)
# Description: SHA256 hash from GitHub release

ACTUAL_CHECKSUM
# Type: String (64 hex chars)
# Description: SHA256 hash of downloaded file

GREEN, YELLOW, RED, BLUE, NC
# Type: String (ANSI escape codes)
# Description: Color codes for terminal output
```

---

## install-docker-mac.sh

### Functions

No exported functions (standalone script)

### Variables

```bash
ARCH
# Type: String
# Values: "arm64", "x86_64"
# Description: Mac architecture (Apple Silicon or Intel)

DOCKER_URL
# Type: String (URL)
# Description: Platform-specific Docker Desktop download URL

MACOS_VERSION
# Type: String
# Example: "13.2.1"
# Description: Full macOS version string

MACOS_MAJOR
# Type: Integer
# Example: 13
# Description: Major macOS version number
```

---

## install-docker-windows.ps1

### Functions

No exported functions (standalone script)

### Variables

```powershell
$dockerUrl
# Type: String (URL)
# Description: Docker Desktop installer download URL

$installerPath
# Type: String (file path)
# Description: Local path for downloaded installer
```

---

## docker-manager.sh

### Functions

```bash
detect_runtime()
# Purpose: Detect which container runtime is installed
# Parameters: None
# Returns: Sets RUNTIME and RUNTIME_NAME variables
# Side effects: Exits if no runtime found
# Usage: detect_runtime

check_runtime_installed()
# Purpose: Verify container runtime exists and exit if not
# Parameters: None
# Returns: None (exits on failure)
# Usage: check_runtime_installed

check_docker_status()
# Purpose: Display runtime status and version information
# Parameters: None
# Returns: None
# Output: Status, version, and basic info
# Usage: check_docker_status

start_docker()
# Purpose: Start Docker service or explain Podman is daemonless
# Parameters: None
# Returns: None
# Platform-specific: Uses systemctl (Linux) or open (macOS)
# Usage: start_docker

stop_docker()
# Purpose: Stop Docker service or stop all Podman containers
# Parameters: None
# Returns: None
# Platform-specific: Different behavior for Docker vs Podman
# Usage: stop_docker

restart_docker()
# Purpose: Restart Docker service or offer Podman system reset
# Parameters: None
# Returns: None
# Confirmation: Asks before Podman system reset
# Usage: restart_docker

view_containers()
# Purpose: List running containers with interactive options
# Parameters: None
# Returns: None
# Interactive: Offers to view logs, stop, or restart containers
# Usage: view_containers

view_all_containers()
# Purpose: List all containers including stopped ones
# Parameters: None
# Returns: None
# Output: Formatted table with names, status, ports
# Usage: view_all_containers

list_images()
# Purpose: Display all images with size information
# Parameters: None
# Returns: None
# Interactive: Offers to pull or remove images
# Usage: list_images

cleanup_docker()
# Purpose: Interactive cleanup menu
# Parameters: None
# Returns: None
# Options: Containers, images, volumes, all, or build cache
# Confirmation: Asks before destructive operations
# Usage: cleanup_docker

show_system_info()
# Purpose: Display runtime system information
# Parameters: None
# Returns: None
# Output: Version, storage driver, cgroup, etc.
# Usage: show_system_info

run_test_container()
# Purpose: Run hello-world container for verification
# Parameters: None
# Returns: None
# Output: Container output and success/failure message
# Usage: run_test_container

show_menu()
# Purpose: Display main menu and handle user selection
# Parameters: None
# Returns: None (calls appropriate function based on choice)
# Loop: Returns to menu after each operation
# Usage: show_menu

main()
# Purpose: Main program loop
# Parameters: None
# Returns: Exit code
# Flow: detect_runtime → check_installed → loop show_menu
# Usage: main
```

### Variables

```bash
RUNTIME
# Type: String
# Values: "docker", "podman", "none"
# Description: Detected container runtime

RUNTIME_NAME
# Type: String
# Values: "Docker", "Podman", "None"
# Description: Human-readable runtime name

PLATFORM
# Type: String
# Values: "Linux", "Mac"
# Description: Detected platform (affects service management)

# Color codes
GREEN='\033[0;32m'
# Usage: Success messages, running status

BLUE='\033[0;34m'
# Usage: Information, Docker-specific

YELLOW='\033[1;33m'
# Usage: Warnings, notes

RED='\033[0;31m'
# Usage: Errors, stopped status

CYAN='\033[0;36m'
# Usage: Headers, menu titles

MAGENTA='\033[0;35m'
# Usage: Podman-specific messages

NC='\033[0m'
# Usage: Reset color to default
```

---

## Exit Codes

### Standard Exit Codes

```bash
0   # Success
1   # General error
2   # Misuse of shell command
126 # Command cannot execute
127 # Command not found
130 # Script terminated by Ctrl+C
```

### Custom Exit Codes

```bash
10  # Prerequisites not met
11  # Unsupported OS/version
12  # Installation failed
13  # Verification failed (with user override option)
14  # No container runtime found
```

---

## Environment Variables

### Used by Scripts

```bash
$HOME
# Description: User's home directory
# Used for: Configuration files, aliases

$USER
# Description: Current username
# Used for: Docker group addition

$SHELL
# Description: User's default shell
# Used for: Determining config file (.bashrc, .zshrc)

$TMPDIR
# Description: Temporary directory
# Used for: Download staging
```

### Set by Scripts

```bash
DOCKER_BUILDKIT
# Optional: Enable BuildKit for builds
# Value: 1
# Scope: Can be set in shell profile

DOCKER_CONTENT_TRUST
# Optional: Enable image verification
# Value: 1
# Scope: Can be set in shell profile
```

---

## File Locations

### Configuration Files

```bash
# Docker daemon config (Linux)
/etc/docker/daemon.json

# Docker systemd overrides (Linux)
/etc/systemd/system/docker.service.d/

# Podman config (Linux)
~/.config/containers/storage.conf
~/.config/containers/registries.conf

# Shell aliases (Linux)
~/.bashrc
~/.zshrc
```

### Installation Paths

```bash
# Docker Compose binary (Linux)
/usr/local/bin/docker-compose

# Docker Desktop (macOS)
/Applications/Docker.app

# Podman binaries (Linux)
/usr/bin/podman
/usr/bin/podman-compose
```

### Runtime Files

```bash
# Docker socket (Linux)
/var/run/docker.sock

# Podman socket (Linux, rootless)
/run/user/$(id -u)/podman/podman.sock

# Docker logs (Linux)
/var/log/docker.log
journalctl -u docker
```

---

## Platform Detection

### OS Detection

```bash
# Bash
OS="$(uname -s)"
# Returns: "Linux", "Darwin", etc.

# Platform check
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
fi
```

### Architecture Detection

```bash
ARCH="$(uname -m)"
# Returns: "x86_64", "arm64", "aarch64"

# Normalize
case "$ARCH" in
    x86_64|amd64) ARCH="amd64" ;;
    aarch64|arm64) ARCH="arm64" ;;
esac
```

### Distribution Detection (Linux)

```bash
# Using lsb_release
DISTRO=$(lsb_release -is)
# Returns: "Ubuntu", "Debian", etc.

# Using /etc/os-release
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
fi
```

---

[⬅ Back to Home](Home)
