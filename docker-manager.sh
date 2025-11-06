#!/bin/bash
# Universal Docker Manager - Interactive Menu
# Version: 1.0.0
# Easy-to-use menu for managing Docker (beginner-friendly)

# Color codes for better visual feedback
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Detect OS for platform-specific commands
OS="$(uname -s)"
case "${OS}" in
    Linux*)     PLATFORM=Linux;;
    Darwin*)    PLATFORM=Mac;;
    *)          PLATFORM="UNKNOWN";;
esac

# Function to pause and wait for user
pause() {
    echo ""
    read -p "Press Enter to continue..."
}

# Function to display header
show_header() {
    clear
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}     Docker Manager - Easy Mode 🐳${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""
}

# Function to check if Docker is installed
check_docker_installed() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}ERROR: Docker is not installed!${NC}"
        echo ""
        echo "Please install Docker first using the installer scripts."
        pause
        exit 1
    fi
}

# Function to check Docker status
check_docker_status() {
    show_header
    echo -e "${BLUE}Checking Docker Status...${NC}"
    echo ""

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
    pause
}

# Function to start Docker
start_docker() {
    show_header
    echo -e "${BLUE}Starting Docker...${NC}"
    echo ""

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

# Function to stop Docker
stop_docker() {
    show_header
    echo -e "${BLUE}Stopping Docker...${NC}"
    echo ""

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

# Function to restart Docker
restart_docker() {
    show_header
    echo -e "${BLUE}Restarting Docker...${NC}"
    echo ""

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

    if ! docker info &> /dev/null; then
        echo -e "${RED}Docker is not running. Please start Docker first.${NC}"
        pause
        return
    fi

    CONTAINER_COUNT=$(docker ps -q | wc -l | tr -d ' ')

    if [ "$CONTAINER_COUNT" -eq 0 ]; then
        echo -e "${YELLOW}No containers are currently running.${NC}"
        echo ""
        echo "To see all containers (including stopped ones), use option 6."
    else
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
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
                docker stop "$container_id"
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
                docker logs --tail 50 -f "$container_id"
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

    if ! docker info &> /dev/null; then
        echo -e "${RED}Docker is not running. Please start Docker first.${NC}"
        pause
        return
    fi

    TOTAL_COUNT=$(docker ps -a -q | wc -l | tr -d ' ')

    if [ "$TOTAL_COUNT" -eq 0 ]; then
        echo -e "${YELLOW}No containers found.${NC}"
    else
        docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"
        echo ""
        echo -e "${GREEN}Total: $TOTAL_COUNT container(s)${NC}"
    fi
    pause
}

# Function to list images
list_images() {
    show_header
    echo -e "${BLUE}Docker Images:${NC}"
    echo ""

    if ! docker info &> /dev/null; then
        echo -e "${RED}Docker is not running. Please start Docker first.${NC}"
        pause
        return
    fi

    IMAGE_COUNT=$(docker images -q | wc -l | tr -d ' ')

    if [ "$IMAGE_COUNT" -eq 0 ]; then
        echo -e "${YELLOW}No images found.${NC}"
        echo ""
        echo "Images are downloaded when you run containers."
    else
        docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
        echo ""
        echo -e "${GREEN}Total: $IMAGE_COUNT image(s)${NC}"

        # Calculate total size
        TOTAL_SIZE=$(docker images --format "{{.Size}}" | sed 's/[A-Z]*B//' | awk '{s+=$1} END {print s}')
        echo -e "${YELLOW}Approximate total size: ${TOTAL_SIZE}MB${NC}"
    fi
    pause
}

# Function to cleanup Docker resources
cleanup_docker() {
    show_header
    echo -e "${BLUE}Docker Cleanup Menu${NC}"
    echo ""

    if ! docker info &> /dev/null; then
        echo -e "${RED}Docker is not running. Please start Docker first.${NC}"
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
            docker container prune -f
            echo -e "${GREEN}✓ Done!${NC}"
            pause
            ;;
        2)
            echo ""
            echo "Removing unused images..."
            docker image prune -a -f
            echo -e "${GREEN}✓ Done!${NC}"
            pause
            ;;
        3)
            echo ""
            echo "Removing unused volumes..."
            docker volume prune -f
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
                docker system prune -a --volumes -f
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

# Function to show Docker system info
show_system_info() {
    show_header
    echo -e "${BLUE}Docker System Information:${NC}"
    echo ""

    if ! docker info &> /dev/null; then
        echo -e "${RED}Docker is not running. Please start Docker first.${NC}"
        pause
        return
    fi

    echo -e "${GREEN}Version Information:${NC}"
    docker --version
    docker compose version 2>/dev/null || docker-compose --version 2>/dev/null
    echo ""

    echo -e "${GREEN}Resource Usage:${NC}"
    docker info 2>/dev/null | grep -E "Containers:|Images:|Server Version:|Operating System:|Total Memory:|CPUs:"
    echo ""

    echo -e "${GREEN}Disk Usage:${NC}"
    docker system df

    pause
}

# Function to run a test container
run_test_container() {
    show_header
    echo -e "${BLUE}Running Test Container${NC}"
    echo ""

    if ! docker info &> /dev/null; then
        echo -e "${RED}Docker is not running. Please start Docker first.${NC}"
        pause
        return
    fi

    echo "This will download and run a simple 'hello-world' container"
    echo "to verify Docker is working correctly."
    echo ""
    read -p "Continue? (y/n): " confirm

    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        echo ""
        docker run hello-world
        echo ""
        echo -e "${GREEN}If you see the message above, Docker is working correctly!${NC}"
    fi
    pause
}

# Main menu
show_menu() {
    show_header

    # Show quick status
    if docker info &> /dev/null; then
        echo -e "${GREEN}● Docker is running${NC}"
    else
        echo -e "${RED}● Docker is not running${NC}"
    fi
    echo ""

    RUNNING_CONTAINERS=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
    if [ ! -z "$RUNNING_CONTAINERS" ] && [ "$RUNNING_CONTAINERS" -gt 0 ]; then
        echo -e "${BLUE}Running containers: $RUNNING_CONTAINERS${NC}"
        echo ""
    fi

    echo -e "${YELLOW}What would you like to do?${NC}"
    echo ""
    echo "  ${GREEN}Basic Operations:${NC}"
    echo "    1.  Check Docker status"
    echo "    2.  Start Docker"
    echo "    3.  Stop Docker"
    echo "    4.  Restart Docker"
    echo ""
    echo "  ${GREEN}Manage Containers & Images:${NC}"
    echo "    5.  View running containers"
    echo "    6.  View all containers (including stopped)"
    echo "    7.  List images"
    echo "    8.  Clean up unused resources"
    echo ""
    echo "  ${GREEN}Information & Testing:${NC}"
    echo "    9.  Show system information"
    echo "    10. Run test container (hello-world)"
    echo ""
    echo "  ${GREEN}Exit:${NC}"
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
            echo "Thanks for using Docker Manager! 🐳"
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
    # Check if Docker is installed
    check_docker_installed

    # Main loop
    while true; do
        show_menu
    done
}

# Run the program
main
