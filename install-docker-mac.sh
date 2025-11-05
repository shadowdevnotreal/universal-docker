#!/bin/bash
set -euo pipefail

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
