#!/bin/bash
# Universal Docker Installer - Linux Script
# Version: 1.0.0
# Installs Docker Engine, Docker CLI, and Docker Compose on Ubuntu/Debian systems

set -euo pipefail  # Exit on error, undefined variable, or pipe failure

# Color codes for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "========================================"
echo "  Docker Engine Installer for Linux"
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

# Check for sudo privileges
if ! sudo -n true 2>/dev/null; then
    echo "This script requires sudo privileges."
    echo "You may be prompted for your password."
fi

# Check for required tools
if ! command -v curl &> /dev/null; then
    echo "ERROR: curl is not installed. Please install curl first."
    echo "Run: sudo apt-get install curl"
    exit 1
fi

# Fetch latest Docker Compose version from GitHub API
# Falls back to known version if API is unavailable (rate limiting or network issues)
echo "Fetching latest Docker Compose version..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)

# Handle API rate limiting or network failures
if [ -z "$DOCKER_COMPOSE_VERSION" ]; then
    echo "Note: Could not fetch latest version from GitHub API (rate limit or network issue)"
    # Fallback to a recent known version (update this periodically)
    DOCKER_COMPOSE_VERSION="v2.24.5"
    echo "Using fallback version: $DOCKER_COMPOSE_VERSION"
else
    echo "Latest version: $DOCKER_COMPOSE_VERSION"
fi
echo ""

# Check if the system is Ubuntu or Debian-based
if ! lsb_release -a 2>/dev/null | grep -iqE 'Ubuntu|Debian'; then
  echo "ERROR: This script is designed for Ubuntu or Debian-based systems only."
  echo "Your system is not supported by this installer."
  exit 1
fi

echo "✓ System check passed"
echo ""
echo "Choose your container runtime:"
echo ""
echo "  1. Docker Engine (traditional, most compatible)"
echo "     - Industry standard"
echo "     - Requires daemon running in background"
echo "     - Full Docker Compose support"
echo ""
echo "  2. Podman (lightweight, daemonless)"
echo "     - No background daemon (uses less resources)"
echo "     - Rootless containers by default (more secure)"
echo "     - Docker-compatible commands"
echo "     - Great for development and testing"
echo ""
read -p "Enter your choice (1 or 2): " runtime_choice
echo ""

if [ "$runtime_choice" = "2" ]; then
    INSTALL_PODMAN=true
    echo "Installing Podman..."
else
    INSTALL_PODMAN=false
    echo "Installing Docker Engine..."
fi
echo ""

# Update the system
echo "[Step 1/3] Updating the system..."
sudo apt-get update && sudo apt-get upgrade -y
echo "✓ System updated"
echo ""

if [ "$INSTALL_PODMAN" = true ]; then
    # Install Podman
    echo "[Step 2/3] Installing Podman..."
    if ! sudo apt-get install -y podman; then
        echo "ERROR: Failed to install Podman from apt."
        echo "Trying alternative method..."

        # Try adding repository for newer Podman version
        echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_$(lsb_release -rs)/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
        curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_$(lsb_release -rs)/Release.key" | sudo apt-key add -
        sudo apt-get update
        sudo apt-get install -y podman
    fi
    echo "✓ Podman installed"
    echo ""

    # Setup Docker compatibility
    echo "[Step 3/3] Setting up Docker compatibility..."

    # Create docker alias for podman
    if ! grep -q "alias docker='podman'" ~/.bashrc; then
        echo "alias docker='podman'" >> ~/.bashrc
        echo "alias docker-compose='podman-compose'" >> ~/.bashrc
    fi

    # Try to install podman-compose
    echo "Installing podman-compose for Docker Compose compatibility..."
    if command -v pip3 &> /dev/null; then
        pip3 install --user podman-compose
        echo "✓ podman-compose installed"
    else
        echo "Note: pip3 not found. You can install podman-compose later with:"
        echo "  sudo apt-get install python3-pip"
        echo "  pip3 install podman-compose"
    fi

    echo "✓ Docker compatibility configured"
    echo ""

    echo "========================================"
    echo "  Installation Complete!"
    echo "========================================"
    echo ""
    podman --version
    echo ""
    echo "Podman is installed! It's Docker-compatible:"
    echo "  - Use 'podman' command (or 'docker' alias after restarting terminal)"
    echo "  - No daemon needed - containers start on demand"
    echo "  - Rootless by default - more secure"
    echo ""
    echo "Quick Start:"
    echo "  - Test Podman: podman run hello-world"
    echo "  - Restart your terminal to use 'docker' alias"
    echo ""

else
    # Install Docker Engine & CLI
    echo "[Step 2/3] Installing Docker Engine and CLI..."
    if ! curl -fsSL https://get.docker.com -o get-docker.sh; then
        echo "ERROR: Failed to download Docker installation script."
        echo "Please check your internet connection and try again."
        exit 1
    fi
    # Note: Docker's official get.docker.sh script handles GPG verification of packages
    # Security-conscious users can manually inspect get-docker.sh before running
    sudo sh get-docker.sh
    rm -f get-docker.sh
    echo "✓ Docker Engine installed"
    echo ""

    # Install Docker Compose
    echo "[Step 3/3] Installing Docker Compose (version ${DOCKER_COMPOSE_VERSION})..."

    # Download Docker Compose binary
    if ! sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose; then
        echo "ERROR: Failed to download Docker Compose."
        echo "Docker Engine was installed successfully, but Docker Compose installation failed."
        exit 1
    fi

    # Download SHA256 checksum for verification
    # This ensures the downloaded binary hasn't been corrupted or tampered with
    echo "Verifying Docker Compose integrity..."
    COMPOSE_CHECKSUM_URL="https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m).sha256"
    if curl -sL "$COMPOSE_CHECKSUM_URL" -o /tmp/docker-compose.sha256 2>/dev/null; then
        # Extract just the checksum (format: "hash  filename" or just "hash")
        EXPECTED_CHECKSUM=$(cat /tmp/docker-compose.sha256 | awk '{print $1}')
        ACTUAL_CHECKSUM=$(sha256sum /usr/local/bin/docker-compose | awk '{print $1}')

        if [ "$EXPECTED_CHECKSUM" = "$ACTUAL_CHECKSUM" ]; then
            echo "✓ Docker Compose integrity verified"
        else
            echo "WARNING: Docker Compose checksum verification failed!"
            echo "Expected: $EXPECTED_CHECKSUM"
            echo "Got: $ACTUAL_CHECKSUM"
            echo "The download may be corrupted or tampered with."
            read -p "Do you want to continue anyway? (y/n): " response
            case $response in
                [Yy]*) echo "Continuing despite checksum mismatch...";;
                *)
                    sudo rm /usr/local/bin/docker-compose
                    rm -f /tmp/docker-compose.sha256
                    echo "Installation aborted for security."
                    exit 1
                    ;;
            esac
        fi
        rm -f /tmp/docker-compose.sha256
    else
        echo "Note: Could not verify Docker Compose checksum (checksum file not available)"
        echo "Proceeding with installation..."
    fi

    sudo chmod +x /usr/local/bin/docker-compose
    echo "✓ Docker Compose installed"
    echo ""

    echo "========================================"
    echo "  Installation Complete!"
    echo "========================================"
    echo ""
    docker --version
    docker-compose --version
    echo ""
    echo "Next steps:"
    echo "  - Add your user to the docker group: sudo usermod -aG docker \$USER"
    echo "  - Log out and back in for group changes to take effect"
    echo "  - Test Docker: docker run hello-world"
    echo ""
fi
echo -e "${GREEN}🎉 NEW: Docker Manager Tool Available!${NC}"
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
