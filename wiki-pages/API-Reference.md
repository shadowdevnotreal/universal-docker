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
