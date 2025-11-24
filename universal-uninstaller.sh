#!/bin/bash
# Universal Docker/Podman Uninstaller
# Version: 1.0.0
# Removes Docker or Podman from Linux and macOS systems

set -euo pipefail  # Exit on error, undefined variable, or pipe failure

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     PLATFORM=Linux;;
    Darwin*)    PLATFORM=Mac;;
    *)          PLATFORM="UNKNOWN";;
esac

# Function to detect what's installed
detect_installed() {
    DOCKER_INSTALLED=false
    PODMAN_INSTALLED=false

    if command -v docker &> /dev/null; then
        DOCKER_INSTALLED=true
    fi

    if command -v podman &> /dev/null; then
        PODMAN_INSTALLED=true
    fi
}

# Function to uninstall Docker on Linux
uninstall_docker_linux() {
    echo -e "${BLUE}[Step 1/3] Stopping Docker service...${NC}"
    sudo systemctl stop docker 2>/dev/null || true
    sudo systemctl disable docker 2>/dev/null || true
    echo -e "${GREEN}✓ Docker service stopped${NC}"
    echo ""

    echo -e "${BLUE}[Step 2/3] Removing Docker packages...${NC}"
    sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 2>/dev/null || true
    sudo apt-get purge -y docker docker-engine docker.io containerd runc 2>/dev/null || true
    sudo rm -f /usr/local/bin/docker-compose
    echo -e "${GREEN}✓ Docker packages removed${NC}"
    echo ""

    echo -e "${BLUE}[Step 3/3] Cleaning up Docker files...${NC}"
    if [ "$REMOVE_DATA" = true ]; then
        echo "Removing Docker data directories..."
        sudo rm -rf /var/lib/docker
        sudo rm -rf /var/lib/containerd
        sudo rm -rf /etc/docker
        sudo rm -rf ~/.docker
        echo -e "${GREEN}✓ Docker data removed${NC}"
    else
        echo -e "${YELLOW}Keeping Docker data (can be removed manually later)${NC}"
        echo "  Locations: /var/lib/docker, /etc/docker, ~/.docker"
    fi
    echo ""

    echo -e "${GREEN}✓ Docker uninstallation complete!${NC}"
}

# Function to uninstall Podman on Linux
uninstall_podman_linux() {
    echo -e "${BLUE}[Step 1/2] Removing Podman packages...${NC}"
    sudo apt-get purge -y podman 2>/dev/null || true
    pip3 uninstall -y podman-compose 2>/dev/null || true
    echo -e "${GREEN}✓ Podman packages removed${NC}"
    echo ""

    echo -e "${BLUE}[Step 2/2] Cleaning up Podman files...${NC}"

    # Remove aliases from bashrc
    if grep -q "alias docker='podman'" ~/.bashrc 2>/dev/null; then
        sed -i "/alias docker='podman'/d" ~/.bashrc
        sed -i "/alias docker-compose='podman-compose'/d" ~/.bashrc
        echo "✓ Removed Podman aliases from ~/.bashrc"
    fi

    if [ "$REMOVE_DATA" = true ]; then
        echo "Removing Podman data directories..."
        rm -rf ~/.local/share/containers
        rm -rf ~/.config/containers
        sudo rm -rf /var/lib/containers 2>/dev/null || true
        echo -e "${GREEN}✓ Podman data removed${NC}"
    else
        echo -e "${YELLOW}Keeping Podman data (can be removed manually later)${NC}"
        echo "  Locations: ~/.local/share/containers, ~/.config/containers"
    fi
    echo ""

    echo -e "${GREEN}✓ Podman uninstallation complete!${NC}"
}

# Function to uninstall Docker on macOS
uninstall_docker_mac() {
    echo -e "${BLUE}[Step 1/3] Stopping Docker Desktop...${NC}"
    osascript -e 'quit app "Docker"' 2>/dev/null || true
    sleep 2
    echo -e "${GREEN}✓ Docker Desktop stopped${NC}"
    echo ""

    echo -e "${BLUE}[Step 2/3] Removing Docker Desktop application...${NC}"
    if [ -d "/Applications/Docker.app" ]; then
        sudo rm -rf /Applications/Docker.app
        echo -e "${GREEN}✓ Docker Desktop removed${NC}"
    else
        echo -e "${YELLOW}Docker Desktop not found in /Applications${NC}"
    fi
    echo ""

    echo -e "${BLUE}[Step 3/3] Cleaning up Docker files...${NC}"
    if [ "$REMOVE_DATA" = true ]; then
        echo "Removing Docker data and configuration..."
        rm -rf ~/Library/Group\ Containers/group.com.docker
        rm -rf ~/Library/Containers/com.docker.docker
        rm -rf ~/.docker
        echo -e "${GREEN}✓ Docker data removed${NC}"
    else
        echo -e "${YELLOW}Keeping Docker data (can be removed manually later)${NC}"
        echo "  Locations: ~/Library/Group Containers/group.com.docker"
        echo "             ~/Library/Containers/com.docker.docker"
        echo "             ~/.docker"
    fi
    echo ""

    echo -e "${GREEN}✓ Docker Desktop uninstallation complete!${NC}"
}

# Function to uninstall Podman on macOS
uninstall_podman_mac() {
    echo -e "${BLUE}[Step 1/3] Stopping Podman machine...${NC}"
    podman machine stop 2>/dev/null || true
    echo -e "${GREEN}✓ Podman machine stopped${NC}"
    echo ""

    echo -e "${BLUE}[Step 2/3] Removing Podman...${NC}"
    if command -v brew &> /dev/null; then
        brew uninstall podman
        echo -e "${GREEN}✓ Podman uninstalled via Homebrew${NC}"
    else
        echo -e "${YELLOW}Homebrew not found - attempting manual removal${NC}"
        sudo rm -f /usr/local/bin/podman
        sudo rm -f /opt/homebrew/bin/podman
    fi
    echo ""

    echo -e "${BLUE}[Step 3/3] Cleaning up Podman files...${NC}"
    if [ "$REMOVE_DATA" = true ]; then
        echo "Removing Podman data and configuration..."
        rm -rf ~/.local/share/containers
        rm -rf ~/.config/containers
        podman machine rm -f 2>/dev/null || true
        echo -e "${GREEN}✓ Podman data removed${NC}"
    else
        echo -e "${YELLOW}Keeping Podman data (can be removed manually later)${NC}"
        echo "  Locations: ~/.local/share/containers"
        echo "             ~/.config/containers"
        echo "  Machine: podman machine rm"
    fi
    echo ""

    echo -e "${GREEN}✓ Podman uninstallation complete!${NC}"
}

# Main uninstaller function
main() {
    echo -e "${RED}========================================"
    echo "  Docker/Podman Uninstaller"
    echo "========================================${NC}"
    echo ""

    # Detect what's installed
    detect_installed

    if [ "$DOCKER_INSTALLED" = false ] && [ "$PODMAN_INSTALLED" = false ]; then
        echo -e "${YELLOW}No container runtime detected!${NC}"
        echo ""
        echo "Neither Docker nor Podman appears to be installed."
        echo "Nothing to uninstall."
        exit 0
    fi

    # Show what's installed
    echo "Detected installations:"
    if [ "$DOCKER_INSTALLED" = true ]; then
        echo -e "  ${GREEN}● Docker${NC}"
        docker --version 2>/dev/null || true
    fi
    if [ "$PODMAN_INSTALLED" = true ]; then
        echo -e "  ${GREEN}● Podman${NC}"
        podman --version 2>/dev/null || true
    fi
    echo ""

    # Warning
    echo -e "${RED}WARNING: This will remove container software from your system!${NC}"
    echo ""

    # Ask what to uninstall
    if [ "$DOCKER_INSTALLED" = true ] && [ "$PODMAN_INSTALLED" = true ]; then
        echo "What would you like to uninstall?"
        echo "  1. Docker only"
        echo "  2. Podman only"
        echo "  3. Both Docker and Podman"
        echo "  4. Cancel"
        echo ""
        read -p "Enter your choice (1-4): " uninstall_choice
        echo ""
    else
        uninstall_choice="auto"
    fi

    # Ask about data removal
    echo "Do you want to remove all container images, volumes, and configurations?"
    echo -e "${YELLOW}(Recommended if you're completely removing the software)${NC}"
    echo ""
    read -p "Remove all data? (y/n): " remove_data_choice
    echo ""

    if [ "$remove_data_choice" = "y" ] || [ "$remove_data_choice" = "Y" ]; then
        REMOVE_DATA=true
    else
        REMOVE_DATA=false
    fi

    # Final confirmation
    echo -e "${RED}FINAL CONFIRMATION${NC}"
    echo "This action cannot be undone!"
    read -p "Type 'yes' to proceed: " final_confirm
    echo ""

    if [ "$final_confirm" != "yes" ]; then
        echo "Uninstallation cancelled."
        exit 0
    fi

    # Perform uninstallation based on platform and choice
    if [ "$PLATFORM" = "Linux" ]; then
        case $uninstall_choice in
            1)
                uninstall_docker_linux
                ;;
            2)
                uninstall_podman_linux
                ;;
            3)
                uninstall_docker_linux
                echo ""
                uninstall_podman_linux
                ;;
            auto)
                if [ "$DOCKER_INSTALLED" = true ]; then
                    uninstall_docker_linux
                fi
                if [ "$PODMAN_INSTALLED" = true ]; then
                    uninstall_podman_linux
                fi
                ;;
            *)
                echo "Uninstallation cancelled."
                exit 0
                ;;
        esac

        # Final cleanup
        echo ""
        echo "Running system cleanup..."
        sudo apt-get autoremove -y
        sudo apt-get autoclean

    elif [ "$PLATFORM" = "Mac" ]; then
        case $uninstall_choice in
            1)
                uninstall_docker_mac
                ;;
            2)
                uninstall_podman_mac
                ;;
            3)
                uninstall_docker_mac
                echo ""
                uninstall_podman_mac
                ;;
            auto)
                if [ "$DOCKER_INSTALLED" = true ]; then
                    uninstall_docker_mac
                fi
                if [ "$PODMAN_INSTALLED" = true ]; then
                    uninstall_podman_mac
                fi
                ;;
            *)
                echo "Uninstallation cancelled."
                exit 0
                ;;
        esac
    else
        echo -e "${RED}ERROR: Unsupported platform: $PLATFORM${NC}"
        exit 1
    fi

    echo ""
    echo -e "${GREEN}========================================"
    echo "  Uninstallation Complete!"
    echo "========================================${NC}"
    echo ""

    if [ "$PLATFORM" = "Linux" ]; then
        echo "Recommended next steps:"
        echo "  - Log out and back in (or reboot)"
        echo "  - Verify removal: docker --version (should return 'not found')"
        if [ "$REMOVE_DATA" = false ]; then
            echo ""
            echo "To manually remove leftover data later:"
            echo "  sudo rm -rf /var/lib/docker /var/lib/containerd"
            echo "  rm -rf ~/.docker ~/.local/share/containers"
        fi
    elif [ "$PLATFORM" = "Mac" ]; then
        echo "Recommended next steps:"
        echo "  - Verify removal: ls /Applications/Docker.app (should not exist)"
        if [ "$REMOVE_DATA" = false ]; then
            echo ""
            echo "To manually remove leftover data later:"
            echo "  rm -rf ~/Library/Group\\ Containers/group.com.docker"
            echo "  rm -rf ~/Library/Containers/com.docker.docker"
            echo "  rm -rf ~/.docker"
        fi
    fi
    echo ""
}

# Check for sudo access on Linux
if [ "$PLATFORM" = "Linux" ]; then
    if ! sudo -n true 2>/dev/null; then
        echo "This script requires sudo privileges on Linux."
        echo "You may be prompted for your password."
        echo ""
    fi
fi

# Run main function
main
