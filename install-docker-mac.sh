#!/bin/bash
set -euo pipefail

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

# Check macOS version (require 10.14 Mojave or newer)
MACOS_VERSION=$(sw_vers -productVersion)
MACOS_MAJOR=$(echo "$MACOS_VERSION" | cut -d '.' -f 1)
MACOS_MINOR=$(echo "$MACOS_VERSION" | cut -d '.' -f 2)

if [ "$MACOS_MAJOR" -lt 10 ] || ([ "$MACOS_MAJOR" -eq 10 ] && [ "$MACOS_MINOR" -lt 14 ]); then
    echo "ERROR: Docker Desktop requires macOS 10.14 (Mojave) or newer."
    echo "Your version: $MACOS_VERSION"
    exit 1
fi

echo "macOS version: $MACOS_VERSION ✓"

# Check for required tools
if ! command -v curl &> /dev/null; then
    echo "ERROR: curl is not installed."
    exit 1
fi

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    echo "Detected Apple Silicon (M1/M2/M3)"
    DOCKER_URL="https://desktop.docker.com/mac/main/arm64/Docker.dmg"
elif [ "$ARCH" = "x86_64" ]; then
    echo "Detected Intel processor"
    DOCKER_URL="https://desktop.docker.com/mac/main/amd64/Docker.dmg"
else
    echo "ERROR: Unknown architecture: $ARCH"
    echo "Please download Docker Desktop manually from https://www.docker.com/products/docker-desktop"
    exit 1
fi

echo "Downloading Docker Desktop for Mac..."
curl -L "$DOCKER_URL" -o ~/Downloads/Docker.dmg

echo "Mounting Docker.dmg..."
hdiutil attach ~/Downloads/Docker.dmg

echo "Installing Docker Desktop..."
sudo cp -R /Volumes/Docker/Docker.app /Applications

echo "Cleanup..."
hdiutil detach /Volumes/Docker
rm ~/Downloads/Docker.dmg

echo "Docker Desktop installed successfully."
