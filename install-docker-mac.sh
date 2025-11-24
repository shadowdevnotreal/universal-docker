#!/bin/bash
# Universal Docker Installer - macOS Script
# Version: 1.0.0
# Installs Docker Desktop on macOS (supports Intel and Apple Silicon)

set -euo pipefail  # Exit on error, undefined variable, or pipe failure

echo "========================================"
echo "  Docker Desktop Installer for macOS"
echo "========================================"
echo ""

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    echo "Docker is already installed:"
    docker --version
    echo ""
    read -p "Do you want to continue anyway? This may overwrite your current installation (y/n): " response
    case $response in
        [Yy]*) echo "Continuing with installation...";;
        *) echo "Installation aborted."; exit 0;;
    esac
fi

# Check macOS version (Docker Desktop requires 10.14 Mojave or newer)
MACOS_VERSION=$(sw_vers -productVersion)
MACOS_MAJOR=$(echo "$MACOS_VERSION" | cut -d '.' -f 1)  # Extract major version (e.g., 10, 11, 12)
MACOS_MINOR=$(echo "$MACOS_VERSION" | cut -d '.' -f 2)  # Extract minor version (e.g., 14, 15)

if [ "$MACOS_MAJOR" -lt 10 ] || ([ "$MACOS_MAJOR" -eq 10 ] && [ "$MACOS_MINOR" -lt 14 ]); then
    echo "ERROR: Docker Desktop requires macOS 10.14 (Mojave) or newer."
    echo "Your version: $MACOS_VERSION"
    exit 1
fi

echo "✓ macOS version: $MACOS_VERSION (compatible)"

# Check for required tools
if ! command -v curl &> /dev/null; then
    echo "ERROR: curl is not installed."
    exit 1
fi

# Detect architecture and select appropriate Docker Desktop download
# arm64 = Apple Silicon (M1/M2/M3), x86_64 = Intel
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    echo "✓ Detected Apple Silicon (M1/M2/M3)"
    DOCKER_URL="https://desktop.docker.com/mac/main/arm64/Docker.dmg"
elif [ "$ARCH" = "x86_64" ]; then
    echo "✓ Detected Intel processor"
    DOCKER_URL="https://desktop.docker.com/mac/main/amd64/Docker.dmg"
else
    echo "ERROR: Unknown architecture: $ARCH"
    echo "Please download Docker Desktop manually from https://www.docker.com/products/docker-desktop"
    exit 1
fi

echo ""
echo "Choose your container runtime:"
echo ""
echo "  1. Docker Desktop (traditional, most compatible)"
echo "     - Industry standard"
echo "     - Full GUI application"
echo "     - Built-in Kubernetes support"
echo "     - ~500MB download"
echo ""
echo "  2. Podman (lightweight, daemonless)"
echo "     - No background daemon (uses less resources)"
echo "     - Docker-compatible commands"
echo "     - Installed via Homebrew (requires Homebrew)"
echo "     - Great for development"
echo ""
read -p "Enter your choice (1 or 2): " runtime_choice
echo ""

if [ "$runtime_choice" = "2" ]; then
    INSTALL_PODMAN=true
    echo "Installing Podman via Homebrew..."
else
    INSTALL_PODMAN=false
    echo "Installing Docker Desktop..."
fi
echo ""

if [ "$INSTALL_PODMAN" = true ]; then
    # Install Podman via Homebrew
    echo "Checking for Homebrew..."
    if ! command -v brew &> /dev/null; then
        echo "ERROR: Homebrew is not installed!"
        echo ""
        echo "Podman on macOS requires Homebrew for installation."
        echo ""
        echo "To install Homebrew, run:"
        echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        echo ""
        echo "Then run this script again."
        exit 1
    fi

    echo "✓ Homebrew is installed"
    echo ""

    echo "[Step 1/3] Installing Podman..."
    brew install podman
    echo "✓ Podman installed"
    echo ""

    echo "[Step 2/3] Initializing Podman machine..."
    podman machine init
    echo "✓ Podman machine initialized"
    echo ""

    echo "[Step 3/3] Starting Podman machine..."
    podman machine start
    echo "✓ Podman machine started"
    echo ""

    echo "========================================"
    echo "  Installation Complete!"
    echo "========================================"
    echo ""
    podman --version
    echo ""
    echo "Podman is installed! It's Docker-compatible:"
    echo "  - Use 'podman' command"
    echo "  - No background daemon - containers run on demand"
    echo "  - Podman machine manages the VM automatically"
    echo ""
    echo "Quick Start:"
    echo "  - Test Podman: podman run hello-world"
    echo "  - Stop machine: podman machine stop"
    echo "  - Start machine: podman machine start"
    echo ""

    # Check if docker-manager.sh exists and offer to launch
    if [ -f "./docker-manager.sh" ]; then
        echo "🎉 NEW: Container Manager Tool Available!"
        echo ""
        echo "We've included an easy-to-use management tool."
        echo "Perfect for beginners - no command line knowledge needed!"
        echo ""
        read -p "Would you like to launch Container Manager now? (y/n): " launch_manager

        if [ "$launch_manager" = "y" ] || [ "$launch_manager" = "Y" ]; then
            echo ""
            chmod +x ./docker-manager.sh
            ./docker-manager.sh
        else
            echo ""
            echo "You can launch Container Manager anytime by running:"
            echo "  ./docker-manager.sh"
            echo ""
        fi
    fi

    exit 0
fi

# Docker Desktop installation continues below
echo "This script will:"
echo "  1. Download Docker Desktop for Mac (~500MB)"
echo "  2. Mount the disk image"
echo "  3. Install Docker Desktop to /Applications"
echo "  4. Clean up temporary files"
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."
echo ""

echo "[Step 1/4] Downloading Docker Desktop for Mac..."
echo "This may take several minutes depending on your connection..."
if ! curl -L "$DOCKER_URL" -o ~/Downloads/Docker.dmg; then
    echo "ERROR: Failed to download Docker Desktop."
    echo "Please check your internet connection and try again."
    exit 1
fi
echo "✓ Download complete"
echo ""

echo "[Step 2/4] Mounting Docker.dmg..."
if ! hdiutil attach ~/Downloads/Docker.dmg 2>/dev/null; then
    echo "ERROR: Failed to mount Docker.dmg"
    echo ""
    echo "Possible causes:"
    echo "  - The download may be corrupted (try running the script again)"
    echo "  - Another volume named 'Docker' may already be mounted"
    echo "  - Insufficient disk space"
    echo ""
    echo "Try manually unmounting: hdiutil detach /Volumes/Docker"
    echo "Then run this script again."
    rm ~/Downloads/Docker.dmg
    exit 1
fi
echo "✓ Disk image mounted"
echo ""

echo "[Step 3/4] Installing Docker Desktop to /Applications..."
echo "(This requires admin privileges - you may be prompted for your password)"
if ! sudo cp -R /Volumes/Docker/Docker.app /Applications; then
    echo "ERROR: Failed to copy Docker.app to /Applications"
    echo ""
    echo "Possible causes:"
    echo "  - Insufficient permissions"
    echo "  - Not enough disk space in /Applications"
    echo "  - Docker.app is currently running (quit it first)"
    echo ""
    hdiutil detach /Volumes/Docker 2>/dev/null || true
    rm ~/Downloads/Docker.dmg
    exit 1
fi
echo "✓ Docker Desktop installed"
echo ""

echo "[Step 4/4] Cleaning up..."
if ! hdiutil detach /Volumes/Docker 2>/dev/null; then
    echo "Note: Could not unmount /Volumes/Docker (may already be unmounted)"
fi
rm -f ~/Downloads/Docker.dmg
echo "✓ Cleanup complete"
echo ""

echo "========================================"
echo "  Installation Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "  - Launch Docker Desktop from /Applications/Docker.app"
echo "  - Docker Desktop will complete setup on first launch"
echo "  - You may need to grant permissions in System Preferences"
echo ""
echo "🎉 NEW: Docker Manager Tool Available!"
echo ""
echo "We've included an easy-to-use management tool for Docker."
echo "Perfect for beginners - no command line knowledge needed!"
echo ""
read -p "Would you like to launch Docker Manager now? (y/n): " launch_manager

if [ "$launch_manager" = "y" ] || [ "$launch_manager" = "Y" ]; then
    echo ""
    if [ -f "./docker-manager.sh" ]; then
        chmod +x ./docker-manager.sh
        ./docker-manager.sh
    else
        echo "Note: docker-manager.sh not found in current directory."
        echo "You can download it from the repository."
    fi
else
    echo ""
    echo "You can launch Docker Manager anytime by running:"
    echo "  ./docker-manager.sh"
    echo ""
fi
