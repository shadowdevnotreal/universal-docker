#!/bin/bash
# Universal Docker Installer - Main Entry Point
# Version: 1.0.0
# Detects OS and routes to appropriate platform-specific installer

set -euo pipefail  # Exit on error, undefined variable, or pipe failure

# Function to install Docker on Linux
install_linux() {
    echo "Starting Docker installation for Linux..."
    ./install-docker-linux.sh
}

# Function to install Docker on macOS
install_mac() {
    echo "Starting Docker installation for macOS..."
    ./install-docker-mac.sh
}

echo "Welcome to the Docker Auto-Installer!"

# Detect the operating system
OS="$(uname -s)"
case "${OS}" in
    Linux*)     OS=Linux;;
    Darwin*)    OS=Mac;;
    *)          OS="UNKNOWN:${OS}"
esac

echo "Detected operating system: ${OS}"

# Check if the operating system is supported and prompt the user for installation
if [ "${OS}" == "Linux" ]; then
    read -p "Do you want to proceed with the Docker installation for Linux? (y/n) " yn
    case $yn in
        [Yy]*) install_linux;;
        *) echo "Installation aborted.";;
    esac
elif [ "${OS}" == "Mac" ]; then
    read -p "Do you want to proceed with the Docker installation for macOS? (y/n) " yn
    case $yn in
        [Yy]*) install_mac;;
        *) echo "Installation aborted.";;
    esac
else
    echo "Sorry, this script does not support your operating system."
    echo "If you are using Windows, please follow the instructions in the README to run the PowerShell script manually."
fi
