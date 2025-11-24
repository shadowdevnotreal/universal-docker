#!/bin/bash
# Universal Docker Toolkit - Main Entry Point
# Version: 2.0.0
# One script to rule them all - Install, Manage, Package, and Uninstall Docker/Podman

set -euo pipefail

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     PLATFORM=Linux;;
    Darwin*)    PLATFORM=Mac;;
    *)          PLATFORM="UNKNOWN";;
esac

# Detect installed runtime
detect_runtime() {
    if command -v docker &> /dev/null; then
        RUNTIME="docker"
        RUNTIME_NAME="Docker"
        INSTALLED=true
    elif command -v podman &> /dev/null; then
        RUNTIME="podman"
        RUNTIME_NAME="Podman"
        INSTALLED=true
    else
        RUNTIME="none"
        RUNTIME_NAME="Not Installed"
        INSTALLED=false
    fi
}

# Function to check if runtime is running
check_runtime_status() {
    if [ "$RUNTIME" = "docker" ]; then
        if docker info &> /dev/null; then
            echo -e "${GREEN}● Docker is running${NC}"
        else
            echo -e "${RED}● Docker is not running${NC}"
        fi
    elif [ "$RUNTIME" = "podman" ]; then
        if podman info &> /dev/null; then
            echo -e "${GREEN}● Podman is ready${NC}"
        else
            echo -e "${YELLOW}● Podman status unknown${NC}"
        fi
    else
        echo -e "${RED}● No container runtime installed${NC}"
    fi
}

# Function to display main header
show_header() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}║          ${MAGENTA}🐳 Universal Docker Toolkit 🐳${CYAN}                  ║${NC}"
    echo -e "${CYAN}║                    ${GREEN}Version 2.0.0${CYAN}                         ║${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Platform:${NC} $PLATFORM"
    echo -e "${BLUE}Runtime:${NC} $RUNTIME_NAME"
    check_runtime_status
    echo ""
}

# Function to launch installer
launch_installer() {
    show_header
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  Install Docker/Podman${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    if [ "$INSTALLED" = true ]; then
        echo -e "${YELLOW}⚠️  $RUNTIME_NAME is already installed!${NC}"
        echo ""
        $RUNTIME --version
        echo ""
        read -p "Do you want to reinstall or install another runtime? (y/n): " confirm
        if [[ ! $confirm =~ ^[Yy]$ ]]; then
            return
        fi
        echo ""
    fi

    if [ ! -f "./universal-installer.sh" ]; then
        echo -e "${RED}❌ Error: universal-installer.sh not found!${NC}"
        echo ""
        echo "Please make sure all script files are in the same directory."
        read -p "Press Enter to continue..."
        return
    fi

    echo -e "${CYAN}Launching installer...${NC}"
    echo ""
    ./universal-installer.sh

    # Refresh runtime detection after installation
    detect_runtime

    echo ""
    read -p "Press Enter to return to main menu..."
}

# Function to launch manager
launch_manager() {
    show_header
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  Container Manager${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    if [ "$INSTALLED" = false ]; then
        echo -e "${RED}❌ No container runtime installed!${NC}"
        echo ""
        echo "Please install Docker or Podman first (Option 1)."
        echo ""
        read -p "Press Enter to continue..."
        return
    fi

    if [ ! -f "./docker-manager.sh" ]; then
        echo -e "${RED}❌ Error: docker-manager.sh not found!${NC}"
        echo ""
        echo "Please make sure all script files are in the same directory."
        read -p "Press Enter to continue..."
        return
    fi

    echo -e "${CYAN}Launching Container Manager...${NC}"
    echo ""
    chmod +x ./docker-manager.sh
    ./docker-manager.sh

    # Refresh runtime detection
    detect_runtime
}

# Function to launch packager
launch_packager() {
    show_header
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  Application Packager${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    if [ "$INSTALLED" = false ]; then
        echo -e "${RED}❌ No container runtime installed!${NC}"
        echo ""
        echo "Please install Docker or Podman first (Option 1)."
        echo ""
        read -p "Press Enter to continue..."
        return
    fi

    if [ ! -f "./docker-packager.sh" ]; then
        echo -e "${RED}❌ Error: docker-packager.sh not found!${NC}"
        echo ""
        echo "Please make sure all script files are in the same directory."
        read -p "Press Enter to continue..."
        return
    fi

    echo -e "${CYAN}Launching Application Packager...${NC}"
    echo ""
    chmod +x ./docker-packager.sh
    ./docker-packager.sh

    # Refresh runtime detection
    detect_runtime
}

# Function to launch uninstaller
launch_uninstaller() {
    show_header
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  Uninstall Docker/Podman${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    if [ "$INSTALLED" = false ]; then
        echo -e "${YELLOW}⚠️  No container runtime detected!${NC}"
        echo ""
        echo "Nothing to uninstall."
        echo ""
        read -p "Press Enter to continue..."
        return
    fi

    if [ ! -f "./universal-uninstaller.sh" ]; then
        echo -e "${RED}❌ Error: universal-uninstaller.sh not found!${NC}"
        echo ""
        echo "Please make sure all script files are in the same directory."
        read -p "Press Enter to continue..."
        return
    fi

    echo -e "${CYAN}Launching uninstaller...${NC}"
    echo ""
    chmod +x ./universal-uninstaller.sh
    ./universal-uninstaller.sh

    # Refresh runtime detection after uninstallation
    detect_runtime

    echo ""
    read -p "Press Enter to return to main menu..."
}

# Function to show help/about
show_about() {
    show_header
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  About Universal Docker Toolkit${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}What is this toolkit?${NC}"
    echo "A complete solution for Docker/Podman on Linux and macOS."
    echo "Everything you need in one place!"
    echo ""
    echo -e "${CYAN}Features:${NC}"
    echo -e "  ${GREEN}●${NC} Install Docker or Podman automatically"
    echo -e "  ${GREEN}●${NC} Manage containers, images, and resources"
    echo -e "  ${GREEN}●${NC} Create Dockerfiles for your projects"
    echo -e "  ${GREEN}●${NC} Generate Docker Compose configurations"
    echo -e "  ${GREEN}●${NC} Build and test containers interactively"
    echo -e "  ${GREEN}●${NC} Clean uninstall when needed"
    echo ""
    echo -e "${CYAN}Perfect for:${NC}"
    echo "  • Beginners learning containers"
    echo "  • Developers wanting quick setup"
    echo "  • DevOps managing multiple projects"
    echo ""
    echo -e "${CYAN}Supported Platforms:${NC}"
    echo "  • Linux (Ubuntu/Debian)"
    echo "  • macOS (Intel & Apple Silicon)"
    echo ""
    echo -e "${CYAN}Repository:${NC}"
    echo "  https://github.com/shadowdevnotreal/universal-docker"
    echo ""
    echo -e "${CYAN}Tools Included:${NC}"
    echo "  1. Universal Installer     - Install Docker/Podman"
    echo "  2. Container Manager       - Manage running containers"
    echo "  3. Application Packager    - Create & build Dockerfiles"
    echo "  4. Universal Uninstaller   - Remove Docker/Podman"
    echo ""
    read -p "Press Enter to continue..."
}

# Main menu
show_main_menu() {
    show_header
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  What would you like to do?${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    if [ "$INSTALLED" = false ]; then
        echo -e "  ${YELLOW}1.${NC} 📥 Install Docker/Podman         ${GREEN}[Start Here!]${NC}"
    else
        echo -e "  ${GREEN}1.${NC} 📥 Install Docker/Podman         [Reinstall]"
    fi

    if [ "$INSTALLED" = true ]; then
        echo -e "  ${GREEN}2.${NC} 🛠️  Manage Containers              ${CYAN}[Recommended]${NC}"
        echo -e "  ${GREEN}3.${NC} 📦 Package Applications           [Create Dockerfiles]"
    else
        echo -e "  ${YELLOW}2.${NC} 🛠️  Manage Containers              ${RED}[Not Available]${NC}"
        echo -e "  ${YELLOW}3.${NC} 📦 Package Applications           ${RED}[Not Available]${NC}"
    fi

    if [ "$INSTALLED" = true ]; then
        echo -e "  ${GREEN}4.${NC} 🗑️  Uninstall Docker/Podman"
    else
        echo -e "  ${YELLOW}4.${NC} 🗑️  Uninstall Docker/Podman       ${RED}[Nothing to Remove]${NC}"
    fi

    echo ""
    echo -e "  ${BLUE}5.${NC} ℹ️  About / Help"
    echo -e "  ${BLUE}6.${NC} ❌ Exit"
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Main program loop
main() {
    # Make all scripts executable
    chmod +x ./*.sh 2>/dev/null || true

    # Main loop
    while true; do
        # Detect runtime status
        detect_runtime

        # Show menu
        show_main_menu

        # Get user choice
        read -p "Enter your choice (1-6): " choice
        echo ""

        case $choice in
            1)
                launch_installer
                ;;
            2)
                launch_manager
                ;;
            3)
                launch_packager
                ;;
            4)
                launch_uninstaller
                ;;
            5)
                show_about
                ;;
            6)
                clear
                echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
                echo ""
                echo -e "  ${CYAN}Thanks for using Universal Docker Toolkit!${NC} 🐳"
                echo ""
                echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
                echo ""
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Invalid choice. Please enter 1-6.${NC}"
                sleep 2
                ;;
        esac
    done
}

# Run main program
main
