#!/bin/bash
set -euo pipefail

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

# Version tracking
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)

# Check if the system is Ubuntu or Debian-based
if ! lsb_release -a 2>/dev/null | grep -iqE 'Ubuntu|Debian'; then
  echo "ERROR: This script is designed for Ubuntu or Debian-based systems only."
  echo "Your system is not supported by this installer."
  exit 1
fi

echo "✓ System check passed"
echo ""
echo "This script will:"
echo "  1. Update your system packages"
echo "  2. Install Docker Engine and CLI"
echo "  3. Install Docker Compose"
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."
echo ""

# Update the system
echo "[Step 1/3] Updating the system..."
sudo apt-get update && sudo apt-get upgrade -y
echo "✓ System updated"
echo ""

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
echo "Verifying Docker Compose integrity..."
COMPOSE_CHECKSUM_URL="https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m).sha256"
if curl -sL "$COMPOSE_CHECKSUM_URL" -o /tmp/docker-compose.sha256 2>/dev/null; then
    # Extract just the checksum (format may vary)
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
