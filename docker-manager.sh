#!/bin/bash
# Universal Docker Manager - Interactive Menu
# Version: 2.0.0
# Easy-to-use menu for managing Docker/Podman (beginner-friendly)

# Color codes for better visual feedback
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Detect OS for platform-specific commands
OS="$(uname -s)"
case "${OS}" in
    Linux*)     PLATFORM=Linux;;
    Darwin*)    PLATFORM=Mac;;
    *)          PLATFORM="UNKNOWN";;
esac

# Detect which container runtime is installed
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

# Initialize runtime detection
detect_runtime

# Function to pause and wait for user
pause() {
    echo ""
    read -p "Press Enter to continue..."
}

# Function to display header
show_header() {
    clear
    echo -e "${CYAN}========================================${NC}"
    if [ "$RUNTIME" = "podman" ]; then
        echo -e "${CYAN}   Container Manager - Easy Mode 📦${NC}"
        echo -e "${MAGENTA}        (Using Podman)${NC}"
    else
        echo -e "${CYAN}   Container Manager - Easy Mode 🐳${NC}"
        echo -e "${BLUE}        (Using Docker)${NC}"
    fi
    echo -e "${CYAN}========================================${NC}"
    echo ""
}

# Function to check if container runtime is installed
check_runtime_installed() {
    detect_runtime
    if [ "$RUNTIME" = "none" ]; then
        echo -e "${RED}ERROR: No container runtime installed!${NC}"
        echo ""
        echo "Please install Docker or Podman first using the installer scripts."
        pause
        exit 1
    fi
}

# Function to check runtime status
check_docker_status() {
    show_header
    echo -e "${BLUE}Checking ${RUNTIME_NAME} Status...${NC}"
    echo ""

    if [ "$RUNTIME" = "podman" ]; then
        # Podman is daemonless, just check if it works
        if podman info &> /dev/null; then
            echo -e "${GREEN}✓ Podman is ready!${NC}"
            echo ""
            echo -e "${YELLOW}Note: Podman is daemonless - no background service needed!${NC}"
            echo ""
            podman --version
            podman-compose --version 2>/dev/null || echo "podman-compose: Not installed"
        else
            echo -e "${RED}✗ Podman is not working properly${NC}"
            echo ""
            echo "Try running: podman system reset"
        fi
    else
        # Docker needs daemon running
        if docker info &> /dev/null; then
            echo -e "${GREEN}✓ Docker is running!${NC}"
            echo ""
            docker --version
            echo ""
            docker compose version 2>/dev/null || docker-compose --version 2>/dev/null || echo "Docker Compose: Not installed"
        else
            echo -e "${RED}✗ Docker is not running${NC}"
            echo ""
            if [ "$PLATFORM" = "Mac" ]; then
                echo "To start Docker on macOS:"
                echo "  - Open Docker Desktop from Applications"
                echo "  - Or use option 2 from the main menu"
            elif [ "$PLATFORM" = "Linux" ]; then
                echo "To start Docker on Linux:"
                echo "  - Use option 2 from the main menu"
                echo "  - Or run: sudo systemctl start docker"
            fi
        fi
    fi
    pause
}

# Function to start runtime
start_docker() {
    show_header
    echo -e "${BLUE}Starting ${RUNTIME_NAME}...${NC}"
    echo ""

    if [ "$RUNTIME" = "podman" ]; then
        echo -e "${YELLOW}Podman is daemonless - no need to start a service!${NC}"
        echo ""
        echo "Podman containers start automatically when you run them."
        echo "Testing Podman..."
        if podman info &> /dev/null; then
            echo ""
            echo -e "${GREEN}✓ Podman is ready to use!${NC}"
        else
            echo -e "${RED}Podman check failed.${NC}"
        fi
        pause
        return
    fi

    # Docker-specific start logic
    if [ "$PLATFORM" = "Mac" ]; then
        echo "Opening Docker Desktop..."
        open -a Docker
        echo ""
        echo -e "${YELLOW}Waiting for Docker to start (this may take 30-60 seconds)...${NC}"

        # Wait for Docker to start (max 2 minutes)
        for i in {1..24}; do
            if docker info &> /dev/null; then
                echo ""
                echo -e "${GREEN}✓ Docker started successfully!${NC}"
                pause
                return
            fi
            sleep 5
            echo -n "."
        done
        echo ""
        echo -e "${YELLOW}Docker is starting... Check Docker Desktop for status.${NC}"

    elif [ "$PLATFORM" = "Linux" ]; then
        echo "Starting Docker service..."
        if sudo systemctl start docker; then
            echo ""
            echo -e "${GREEN}✓ Docker started successfully!${NC}"
        else
            echo ""
            echo -e "${RED}Failed to start Docker${NC}"
            echo "You may need to install Docker first."
        fi
    fi
    pause
}

# Function to stop runtime
stop_docker() {
    show_header
    echo -e "${BLUE}Stopping ${RUNTIME_NAME}...${NC}"
    echo ""

    if [ "$RUNTIME" = "podman" ]; then
        echo -e "${YELLOW}Podman is daemonless - no background service to stop!${NC}"
        echo ""
        echo "However, we can stop all running containers:"
        read -p "Stop all running Podman containers? (y/n): " confirm
        if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
            echo ""
            podman stop -a
            echo -e "${GREEN}✓ All containers stopped${NC}"
        fi
        pause
        return
    fi

    # Docker-specific stop logic
    if [ "$PLATFORM" = "Mac" ]; then
        echo "Stopping Docker Desktop..."
        osascript -e 'quit app "Docker"' 2>/dev/null
        echo ""
        echo -e "${GREEN}✓ Docker Desktop is shutting down${NC}"

    elif [ "$PLATFORM" = "Linux" ]; then
        echo "Stopping Docker service..."
        if sudo systemctl stop docker; then
            echo ""
            echo -e "${GREEN}✓ Docker stopped successfully!${NC}"
        else
            echo ""
            echo -e "${RED}Failed to stop Docker${NC}"
        fi
    fi
    pause
}

# Function to restart runtime
restart_docker() {
    show_header
    echo -e "${BLUE}Restarting ${RUNTIME_NAME}...${NC}"
    echo ""

    if [ "$RUNTIME" = "podman" ]; then
        echo -e "${YELLOW}Podman is daemonless - no service to restart!${NC}"
        echo ""
        echo "You can restart all containers or reset the Podman system:"
        echo "  1. Restart all running containers"
        echo "  2. Reset Podman system (clears everything)"
        echo "  3. Go back"
        echo ""
        read -p "Choose an option (1-3): " restart_choice

        case $restart_choice in
            1)
                echo ""
                echo "Restarting all containers..."
                podman restart -a
                echo -e "${GREEN}✓ Done!${NC}"
                ;;
            2)
                echo ""
                echo -e "${RED}WARNING: This will remove all containers, images, and volumes!${NC}"
                read -p "Are you sure? (yes/no): " confirm
                if [ "$confirm" = "yes" ]; then
                    podman system reset -f
                    echo -e "${GREEN}✓ Podman system reset!${NC}"
                fi
                ;;
            3)
                return
                ;;
        esac
        pause
        return
    fi

    # Docker-specific restart logic
    if [ "$PLATFORM" = "Mac" ]; then
        echo "Restarting Docker Desktop..."
        osascript -e 'quit app "Docker"' 2>/dev/null
        sleep 3
        open -a Docker
        echo ""
        echo -e "${YELLOW}Docker is restarting... This may take a minute.${NC}"

    elif [ "$PLATFORM" = "Linux" ]; then
        echo "Restarting Docker service..."
        if sudo systemctl restart docker; then
            echo ""
            echo -e "${GREEN}✓ Docker restarted successfully!${NC}"
        else
            echo ""
            echo -e "${RED}Failed to restart Docker${NC}"
        fi
    fi
    pause
}

# Function to view running containers
view_containers() {
    show_header
    echo -e "${BLUE}Running Containers:${NC}"
    echo ""

    if ! $RUNTIME info &> /dev/null; then
        echo -e "${RED}${RUNTIME_NAME} is not running. Please start it first.${NC}"
        pause
        return
    fi

    CONTAINER_COUNT=$($RUNTIME ps -q | wc -l | tr -d ' ')

    if [ "$CONTAINER_COUNT" -eq 0 ]; then
        echo -e "${YELLOW}No containers are currently running.${NC}"
        echo ""
        echo "To see all containers (including stopped ones), use option 6."
    else
        $RUNTIME ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        echo ""
        echo -e "${GREEN}Total running: $CONTAINER_COUNT container(s)${NC}"
    fi

    echo ""
    echo "Options:"
    echo "  1. Stop a container"
    echo "  2. View container logs"
    echo "  3. Go back"
    echo ""
    read -p "Choose an option (1-3): " container_choice

    case $container_choice in
        1)
            echo ""
            read -p "Enter container name or ID to stop: " container_id
            if [ ! -z "$container_id" ]; then
                $RUNTIME stop "$container_id"
                echo -e "${GREEN}Container stopped!${NC}"
                pause
            fi
            ;;
        2)
            echo ""
            read -p "Enter container name or ID to view logs: " container_id
            if [ ! -z "$container_id" ]; then
                echo ""
                echo -e "${BLUE}Showing last 50 lines (press Ctrl+C to exit)...${NC}"
                echo ""
                $RUNTIME logs --tail 50 -f "$container_id"
            fi
            ;;
        3)
            return
            ;;
    esac
}

# Function to view all containers (including stopped)
view_all_containers() {
    show_header
    echo -e "${BLUE}All Containers (including stopped):${NC}"
    echo ""

    if ! $RUNTIME info &> /dev/null; then
        echo -e "${RED}${RUNTIME_NAME} is not ready.${NC}"
        pause
        return
    fi

    TOTAL_COUNT=$($RUNTIME ps -a -q | wc -l | tr -d ' ')

    if [ "$TOTAL_COUNT" -eq 0 ]; then
        echo -e "${YELLOW}No containers found.${NC}"
    else
        $RUNTIME ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"
        echo ""
        echo -e "${GREEN}Total: $TOTAL_COUNT container(s)${NC}"
    fi
    pause
}

# Function to list images
list_images() {
    show_header
    echo -e "${BLUE}Container Images:${NC}"
    echo ""

    if ! $RUNTIME info &> /dev/null; then
        echo -e "${RED}${RUNTIME_NAME} is not ready.${NC}"
        pause
        return
    fi

    IMAGE_COUNT=$($RUNTIME images -q | wc -l | tr -d ' ')

    if [ "$IMAGE_COUNT" -eq 0 ]; then
        echo -e "${YELLOW}No images found.${NC}"
        echo ""
        echo "Images are downloaded when you run containers."
    else
        $RUNTIME images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
        echo ""
        echo -e "${GREEN}Total: $IMAGE_COUNT image(s)${NC}"
    fi
    pause
}

# Function to cleanup resources
cleanup_docker() {
    show_header
    echo -e "${BLUE}Container Cleanup Menu${NC}"
    echo ""

    if ! $RUNTIME info &> /dev/null; then
        echo -e "${RED}${RUNTIME_NAME} is not ready.${NC}"
        pause
        return
    fi

    echo "This will help you free up disk space by removing:"
    echo ""
    echo -e "${YELLOW}What would you like to clean up?${NC}"
    echo ""
    echo "  1. Remove stopped containers"
    echo "  2. Remove unused images"
    echo "  3. Remove unused volumes"
    echo "  4. Clean everything (full cleanup)"
    echo "  5. Go back"
    echo ""
    read -p "Choose an option (1-5): " cleanup_choice

    case $cleanup_choice in
        1)
            echo ""
            echo "Removing stopped containers..."
            $RUNTIME container prune -f
            echo -e "${GREEN}✓ Done!${NC}"
            pause
            ;;
        2)
            echo ""
            echo "Removing unused images..."
            $RUNTIME image prune -a -f
            echo -e "${GREEN}✓ Done!${NC}"
            pause
            ;;
        3)
            echo ""
            echo "Removing unused volumes..."
            $RUNTIME volume prune -f
            echo -e "${GREEN}✓ Done!${NC}"
            pause
            ;;
        4)
            echo ""
            echo -e "${RED}WARNING: This will remove:${NC}"
            echo "  - All stopped containers"
            echo "  - All unused images"
            echo "  - All unused volumes"
            echo "  - All unused networks"
            echo ""
            read -p "Are you sure? (yes/no): " confirm
            if [ "$confirm" = "yes" ]; then
                echo ""
                echo "Cleaning up everything..."
                $RUNTIME system prune -a --volumes -f
                echo ""
                echo -e "${GREEN}✓ Full cleanup complete!${NC}"

                # Show space freed
                echo ""
                df -h / | tail -1 | awk '{print "Disk space available: " $4}'
            else
                echo "Cleanup cancelled."
            fi
            pause
            ;;
        5)
            return
            ;;
    esac
}

# Function to show system info
show_system_info() {
    show_header
    echo -e "${BLUE}${RUNTIME_NAME} System Information:${NC}"
    echo ""

    if ! $RUNTIME info &> /dev/null; then
        echo -e "${RED}${RUNTIME_NAME} is not ready.${NC}"
        pause
        return
    fi

    echo -e "${GREEN}Version Information:${NC}"
    $RUNTIME --version
    if [ "$RUNTIME" = "docker" ]; then
        docker compose version 2>/dev/null || docker-compose --version 2>/dev/null
    else
        podman-compose --version 2>/dev/null || echo "podman-compose: Not installed"
    fi
    echo ""

    echo -e "${GREEN}Resource Usage:${NC}"
    $RUNTIME info 2>/dev/null | grep -E "Containers:|Images:|Server Version:|Operating System:|Total Memory:|CPUs:|OCI Runtime:|runRoot:"
    echo ""

    echo -e "${GREEN}Disk Usage:${NC}"
    $RUNTIME system df

    pause
}

# Function to run a test container
run_test_container() {
    show_header
    echo -e "${BLUE}Running Test Container${NC}"
    echo ""

    if ! $RUNTIME info &> /dev/null; then
        echo -e "${RED}${RUNTIME_NAME} is not ready.${NC}"
        pause
        return
    fi

    echo "This will download and run a simple 'hello-world' container"
    echo "to verify ${RUNTIME_NAME} is working correctly."
    echo ""
    read -p "Continue? (y/n): " confirm

    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        echo ""
        $RUNTIME run hello-world
        echo ""
        echo -e "${GREEN}If you see the message above, ${RUNTIME_NAME} is working correctly!${NC}"
    fi
    pause
}

# Main menu
show_menu() {
    show_header

    # Show quick status
    if [ "$RUNTIME" = "podman" ]; then
        if podman info &> /dev/null; then
            echo -e "${GREEN}● Podman is ready (daemonless)${NC}"
        else
            echo -e "${RED}● Podman is not working${NC}"
        fi
    else
        if docker info &> /dev/null; then
            echo -e "${GREEN}● Docker is running${NC}"
        else
            echo -e "${RED}● Docker is not running${NC}"
        fi
    fi
    echo ""

    RUNNING_CONTAINERS=$($RUNTIME ps -q 2>/dev/null | wc -l | tr -d ' ')
    if [ ! -z "$RUNNING_CONTAINERS" ] && [ "$RUNNING_CONTAINERS" -gt 0 ]; then
        echo -e "${BLUE}Running containers: $RUNNING_CONTAINERS${NC}"
        echo ""
    fi

    echo -e "${YELLOW}What would you like to do?${NC}"
    echo ""
    echo -e "  ${GREEN}Basic Operations:${NC}"
    echo "    1.  Check $RUNTIME_NAME status"
    echo "    2.  Start $RUNTIME_NAME"
    echo "    3.  Stop $RUNTIME_NAME"
    echo "    4.  Restart $RUNTIME_NAME"
    echo ""
    echo -e "  ${GREEN}Manage Containers & Images:${NC}"
    echo "    5.  View running containers"
    echo "    6.  View all containers (including stopped)"
    echo "    7.  List images"
    echo "    8.  Clean up unused resources"
    echo ""
    echo -e "  ${GREEN}Information & Testing:${NC}"
    echo "    9.  Show system information"
    echo "    10. Run test container (hello-world)"
    echo ""
    echo -e "  ${GREEN}Exit:${NC}"
    echo "    11. Exit"
    echo ""
    echo "========================================"
    echo ""
    read -p "Enter your choice (1-11): " choice
    echo ""

    case $choice in
        1) check_docker_status ;;
        2) start_docker ;;
        3) stop_docker ;;
        4) restart_docker ;;
        5) view_containers ;;
        6) view_all_containers ;;
        7) list_images ;;
        8) cleanup_docker ;;
        9) show_system_info ;;
        10) run_test_container ;;
        11)
            clear
            if [ "$RUNTIME" = "podman" ]; then
                echo "Thanks for using Container Manager with Podman! 📦"
            else
                echo "Thanks for using Container Manager! 🐳"
            fi
            echo ""
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please choose 1-11.${NC}"
            sleep 2
            ;;
    esac
}

# Main program
main() {
    # Check if container runtime is installed
    check_runtime_installed

    # Main loop
    while true; do
        show_menu
    done
}

# Run the program
main
