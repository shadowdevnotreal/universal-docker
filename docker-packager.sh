#!/bin/bash
# docker-packager.sh - Interactive Docker/Podman Application Packager
# Version: 1.0.0
# Description: Help users create Dockerfiles and package applications

set -euo pipefail

# ============================================================================
# COLOR DEFINITIONS
# ============================================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# ============================================================================
# GLOBAL VARIABLES
# ============================================================================

RUNTIME=""
RUNTIME_NAME=""
BUILD_TOOL=""
BUILD_TOOL_NAME=""
PROJECT_TYPE=""
PROJECT_NAME=""
APP_PORT=""
ENTRY_COMMAND=""

# ============================================================================
# RUNTIME DETECTION
# ============================================================================

detect_runtime() {
    # Detect container runtime (Docker or Podman)
    if command -v docker &> /dev/null; then
        RUNTIME="docker"
        RUNTIME_NAME="Docker"
        BUILD_TOOL="docker"
        BUILD_TOOL_NAME="Docker"
    elif command -v podman &> /dev/null; then
        RUNTIME="podman"
        RUNTIME_NAME="Podman"
        # Podman can use either podman build or buildah
        if command -v buildah &> /dev/null; then
            BUILD_TOOL="buildah"
            BUILD_TOOL_NAME="Buildah"
        else
            BUILD_TOOL="podman"
            BUILD_TOOL_NAME="Podman"
        fi
    else
        RUNTIME="none"
        RUNTIME_NAME="None"
        BUILD_TOOL="none"
        BUILD_TOOL_NAME="None"
    fi
}

check_runtime_installed() {
    if [ "$RUNTIME" = "none" ]; then
        echo -e "${RED}❌ Error: No container runtime found!${NC}"
        echo ""
        echo "Please install Docker or Podman first:"
        echo "  • Run: ./universal-installer.sh"
        echo "  • Or visit: https://github.com/shadowdevnotreal/universal-docker"
        echo ""
        exit 1
    fi
}

# ============================================================================
# PROJECT TYPE DETECTION
# ============================================================================

detect_project_type() {
    echo -e "${CYAN}📁 Detecting project type...${NC}"

    # Node.js detection
    if [ -f "package.json" ]; then
        PROJECT_TYPE="nodejs"
        echo -e "${GREEN}   ✓ Detected: Node.js (found package.json)${NC}"
        return
    fi

    # Python detection
    if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
        PROJECT_TYPE="python"
        echo -e "${GREEN}   ✓ Detected: Python (found Python config)${NC}"
        return
    fi

    # Go detection
    if [ -f "go.mod" ] || [ -f "go.sum" ]; then
        PROJECT_TYPE="go"
        echo -e "${GREEN}   ✓ Detected: Go (found go.mod)${NC}"
        return
    fi

    # Static site detection
    if [ -f "index.html" ] && [ ! -f "package.json" ]; then
        PROJECT_TYPE="static"
        echo -e "${GREEN}   ✓ Detected: Static Site (found index.html)${NC}"
        return
    fi

    # Unknown
    PROJECT_TYPE="unknown"
    echo -e "${YELLOW}   ⚠ Could not auto-detect project type${NC}"
}

# ============================================================================
# MAIN MENU
# ============================================================================

show_header() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}║         ${MAGENTA}🐳 Docker/Podman Application Packager${CYAN}           ║${NC}"
    echo -e "${CYAN}║                     ${GREEN}Version 1.0.0${CYAN}                        ║${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Runtime: ${RUNTIME_NAME}${NC}"
    echo -e "${BLUE}Build Tool: ${BUILD_TOOL_NAME}${NC}"
    echo ""
}

show_menu() {
    show_header

    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  What would you like to do?${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "  1. 📦 Create Dockerfile (Interactive)"
    echo "  2. 🏗️  Build & Test Container"
    echo "  3. 📝 Generate Docker Compose"
    echo "  4. ℹ️  Show Project Info"
    echo "  5. ❌ Exit"
    echo ""
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# ============================================================================
# DOCKERFILE GENERATION
# ============================================================================

generate_dockerfile_nodejs() {
    local port="${1:-3000}"
    local entry="${2:-npm start}"

    cat > Dockerfile << 'EOF'
# Multi-stage build for Node.js application
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application files
COPY . .

# Production stage
FROM node:18-alpine

# Create non-root user
RUN addgroup -g 1001 appuser && \
    adduser -D -u 1001 -G appuser appuser

WORKDIR /app

# Copy from builder
COPY --from=builder --chown=appuser:appuser /app ./

# Switch to non-root user
USER appuser

# Expose port
EOF
    echo "EXPOSE ${port}" >> Dockerfile
    cat >> Dockerfile << 'EOF'

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:${APP_PORT}/', (res) => { process.exit(res.statusCode === 200 ? 0 : 1); })" || exit 1

# Start application
EOF
    echo "CMD ${entry}" >> Dockerfile
}

generate_dockerfile_python() {
    local port="${1:-8000}"
    local entry="${2:-python app.py}"

    cat > Dockerfile << 'EOF'
# Multi-stage build for Python application
FROM python:3.11-slim AS builder

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Production stage
FROM python:3.11-slim

# Create non-root user
RUN useradd -m -u 1001 appuser

WORKDIR /app

# Copy dependencies from builder
COPY --from=builder --chown=appuser:appuser /root/.local /home/appuser/.local

# Copy application files
COPY --chown=appuser:appuser . .

# Make sure scripts in .local are usable
ENV PATH=/home/appuser/.local/bin:$PATH

# Switch to non-root user
USER appuser

# Expose port
EOF
    echo "EXPOSE ${port}" >> Dockerfile
    cat >> Dockerfile << 'EOF'

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:${APP_PORT}/').getcode()" || exit 1

# Start application
EOF
    echo "CMD ${entry}" >> Dockerfile
}

generate_dockerfile_go() {
    local port="${1:-8080}"
    local binary="${2:-app}"

    cat > Dockerfile << 'EOF'
# Multi-stage build for Go application
FROM golang:1.21-alpine AS builder

# Set working directory
WORKDIR /app

# Copy go mod files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build application
EOF
    echo "RUN CGO_ENABLED=0 GOOS=linux go build -o ${binary} ." >> Dockerfile
    cat >> Dockerfile << 'EOF'

# Production stage
FROM alpine:latest

# Install ca-certificates for HTTPS
RUN apk --no-cache add ca-certificates

# Create non-root user
RUN addgroup -g 1001 appuser && \
    adduser -D -u 1001 -G appuser appuser

WORKDIR /app

# Copy binary from builder
EOF
    echo "COPY --from=builder --chown=appuser:appuser /app/${binary} ./" >> Dockerfile
    cat >> Dockerfile << 'EOF'

# Switch to non-root user
USER appuser

# Expose port
EOF
    echo "EXPOSE ${port}" >> Dockerfile
    cat >> Dockerfile << 'EOF'

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:${APP_PORT}/ || exit 1

# Start application
EOF
    echo "CMD [\"./${binary}\"]" >> Dockerfile
}

generate_dockerfile_static() {
    local port="${1:-80}"

    cat > Dockerfile << EOF
# Static site with nginx
FROM nginx:alpine

# Copy static files
COPY . /usr/share/nginx/html

# Create non-root user (nginx already runs as nginx user)
# Expose port
EXPOSE ${port}

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \\
    CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1

# nginx runs automatically
EOF
}

generate_dockerignore() {
    local project_type="$1"

    case "$project_type" in
        nodejs)
            cat > .dockerignore << 'EOF'
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.env.local
.DS_Store
*.log
coverage
.nyc_output
dist
build
EOF
            ;;
        python)
            cat > .dockerignore << 'EOF'
__pycache__
*.pyc
*.pyo
*.pyd
.Python
env/
venv/
.venv/
pip-log.txt
pip-delete-this-directory.txt
.git
.gitignore
README.md
.env
.DS_Store
*.log
.pytest_cache
.coverage
htmlcov
EOF
            ;;
        go)
            cat > .dockerignore << 'EOF'
.git
.gitignore
README.md
.env
.DS_Store
*.log
vendor/
bin/
*.exe
*.test
*.out
EOF
            ;;
        static)
            cat > .dockerignore << 'EOF'
.git
.gitignore
README.md
.DS_Store
*.log
node_modules
.env
EOF
            ;;
        *)
            cat > .dockerignore << 'EOF'
.git
.gitignore
README.md
.env
.DS_Store
*.log
EOF
            ;;
    esac
}

# ============================================================================
# MENU HANDLERS
# ============================================================================

create_dockerfile() {
    show_header
    echo -e "${MAGENTA}📦 Create Dockerfile${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo ""

    # Detect project type
    detect_project_type
    echo ""

    # If unknown, ask user
    if [ "$PROJECT_TYPE" = "unknown" ]; then
        echo -e "${YELLOW}Please select your project type:${NC}"
        echo "  1. Node.js"
        echo "  2. Python"
        echo "  3. Go"
        echo "  4. Static Site (HTML/CSS/JS)"
        echo "  5. Cancel"
        echo ""
        read -p "Enter your choice (1-5): " type_choice

        case $type_choice in
            1) PROJECT_TYPE="nodejs" ;;
            2) PROJECT_TYPE="python" ;;
            3) PROJECT_TYPE="go" ;;
            4) PROJECT_TYPE="static" ;;
            5) return ;;
            *)
                echo -e "${RED}Invalid choice${NC}"
                read -p "Press Enter to continue..."
                return
                ;;
        esac
    else
        echo -e "${BLUE}Detected project type: ${PROJECT_TYPE}${NC}"
        read -p "Is this correct? (y/n): " confirm
        if [[ ! $confirm =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}Please run option 1 again and manually select type${NC}"
            read -p "Press Enter to continue..."
            return
        fi
    fi

    echo ""
    echo -e "${CYAN}Let me ask a few questions...${NC}"
    echo ""

    # Ask for port
    case "$PROJECT_TYPE" in
        nodejs)
            read -p "What port does your app listen on? [3000]: " APP_PORT
            APP_PORT="${APP_PORT:-3000}"
            read -p "Entry point command? [npm start]: " ENTRY_COMMAND
            ENTRY_COMMAND="${ENTRY_COMMAND:-npm start}"
            ;;
        python)
            read -p "What port does your app listen on? [8000]: " APP_PORT
            APP_PORT="${APP_PORT:-8000}"
            read -p "Entry point command? [python app.py]: " ENTRY_COMMAND
            ENTRY_COMMAND="${ENTRY_COMMAND:-python app.py}"
            ;;
        go)
            read -p "What port does your app listen on? [8080]: " APP_PORT
            APP_PORT="${APP_PORT:-8080}"
            read -p "Binary name? [app]: " ENTRY_COMMAND
            ENTRY_COMMAND="${ENTRY_COMMAND:-app}"
            ;;
        static)
            APP_PORT="80"
            ;;
    esac

    echo ""
    echo -e "${CYAN}✨ Generating files...${NC}"

    # Check if Dockerfile exists
    if [ -f "Dockerfile" ]; then
        echo -e "${YELLOW}⚠️  Dockerfile already exists!${NC}"
        read -p "Overwrite? (y/n): " overwrite
        if [[ ! $overwrite =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}Cancelled${NC}"
            read -p "Press Enter to continue..."
            return
        fi
    fi

    # Generate Dockerfile
    case "$PROJECT_TYPE" in
        nodejs)
            generate_dockerfile_nodejs "$APP_PORT" "$ENTRY_COMMAND"
            ;;
        python)
            generate_dockerfile_python "$APP_PORT" "$ENTRY_COMMAND"
            ;;
        go)
            generate_dockerfile_go "$APP_PORT" "$ENTRY_COMMAND"
            ;;
        static)
            generate_dockerfile_static "$APP_PORT"
            ;;
    esac

    echo -e "${GREEN}   ✓ Dockerfile created${NC}"

    # Generate .dockerignore
    generate_dockerignore "$PROJECT_TYPE"
    echo -e "${GREEN}   ✓ .dockerignore created${NC}"

    echo ""
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ Files generated successfully!${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "  • Review the Dockerfile"
    echo "  • Build your image: Option 2 in menu"
    echo "  • Or manually: $BUILD_TOOL build -t myapp:latest ."
    echo ""
    read -p "Press Enter to continue..."
}

build_and_test() {
    show_header
    echo -e "${MAGENTA}🏗️  Build & Test Container${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo ""

    # Check if Dockerfile exists
    if [ ! -f "Dockerfile" ]; then
        echo -e "${RED}❌ No Dockerfile found in current directory${NC}"
        echo ""
        echo "Please create a Dockerfile first (Option 1)"
        echo ""
        read -p "Press Enter to continue..."
        return
    fi

    # Ask for image name
    local default_name=$(basename "$(pwd)" | tr '[:upper:]' '[:lower:]')
    read -p "Image name? [$default_name]: " IMAGE_NAME
    IMAGE_NAME="${IMAGE_NAME:-$default_name}"

    read -p "Image tag? [latest]: " IMAGE_TAG
    IMAGE_TAG="${IMAGE_TAG:-latest}"

    local FULL_IMAGE="${IMAGE_NAME}:${IMAGE_TAG}"

    echo ""
    echo -e "${CYAN}🏗️  Building image: ${FULL_IMAGE}${NC}"
    echo ""

    # Build based on runtime
    if [ "$BUILD_TOOL" = "buildah" ]; then
        echo -e "${BLUE}Using Buildah for build...${NC}"
        if buildah bud -t "$FULL_IMAGE" .; then
            echo ""
            echo -e "${GREEN}✅ Image built successfully!${NC}"
        else
            echo ""
            echo -e "${RED}❌ Build failed!${NC}"
            read -p "Press Enter to continue..."
            return
        fi
    else
        echo -e "${BLUE}Using $BUILD_TOOL_NAME for build...${NC}"
        if $BUILD_TOOL build -t "$FULL_IMAGE" .; then
            echo ""
            echo -e "${GREEN}✅ Image built successfully!${NC}"
        else
            echo ""
            echo -e "${RED}❌ Build failed!${NC}"
            read -p "Press Enter to continue..."
            return
        fi
    fi

    echo ""
    read -p "Would you like to test run the container? (y/n): " run_test
    if [[ ! $run_test =~ ^[Yy]$ ]]; then
        read -p "Press Enter to continue..."
        return
    fi

    # Get port mapping
    echo ""
    read -p "Map to host port? (leave empty to skip port mapping): " HOST_PORT

    local PORT_MAP=""
    if [ -n "$HOST_PORT" ]; then
        read -p "Container port? [${APP_PORT:-8000}]: " CONTAINER_PORT
        CONTAINER_PORT="${CONTAINER_PORT:-${APP_PORT:-8000}}"
        PORT_MAP="-p ${HOST_PORT}:${CONTAINER_PORT}"
    fi

    echo ""
    echo -e "${CYAN}🚀 Running container...${NC}"
    echo ""

    # Run container
    local CONTAINER_NAME="${IMAGE_NAME}-test"

    if [ "$RUNTIME" = "podman" ]; then
        echo -e "${BLUE}Command: podman run --rm --name $CONTAINER_NAME $PORT_MAP $FULL_IMAGE${NC}"
        echo ""
        echo -e "${YELLOW}Press Ctrl+C to stop the container${NC}"
        echo ""
        podman run --rm --name "$CONTAINER_NAME" $PORT_MAP "$FULL_IMAGE"
    else
        echo -e "${BLUE}Command: docker run --rm --name $CONTAINER_NAME $PORT_MAP $FULL_IMAGE${NC}"
        echo ""
        echo -e "${YELLOW}Press Ctrl+C to stop the container${NC}"
        echo ""
        docker run --rm --name "$CONTAINER_NAME" $PORT_MAP "$FULL_IMAGE"
    fi

    echo ""
    read -p "Press Enter to continue..."
}

generate_compose() {
    show_header
    echo -e "${MAGENTA}📝 Generate Docker Compose${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo ""

    # Check if docker-compose.yml exists
    if [ -f "docker-compose.yml" ]; then
        echo -e "${YELLOW}⚠️  docker-compose.yml already exists!${NC}"
        read -p "Overwrite? (y/n): " overwrite
        if [[ ! $overwrite =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}Cancelled${NC}"
            read -p "Press Enter to continue..."
            return
        fi
    fi

    echo -e "${CYAN}Let me ask a few questions...${NC}"
    echo ""

    # Service name
    local service_name=$(basename "$(pwd)" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')
    read -p "Service name? [$service_name]: " SERVICE_NAME
    SERVICE_NAME="${SERVICE_NAME:-$service_name}"

    # Port
    read -p "Host port to expose? [3000]: " HOST_PORT
    HOST_PORT="${HOST_PORT:-3000}"

    read -p "Container port? [3000]: " CONTAINER_PORT
    CONTAINER_PORT="${CONTAINER_PORT:-3000}"

    # Additional services
    echo ""
    echo -e "${CYAN}Additional services:${NC}"
    read -p "Add PostgreSQL? (y/n): " add_postgres
    read -p "Add Redis? (y/n): " add_redis
    read -p "Add MongoDB? (y/n): " add_mongo

    echo ""
    echo -e "${CYAN}✨ Generating docker-compose.yml...${NC}"

    # Generate docker-compose.yml
    cat > docker-compose.yml << EOF
version: '3.8'

services:
  ${SERVICE_NAME}:
    build: .
    ports:
      - "${HOST_PORT}:${CONTAINER_PORT}"
    environment:
      - NODE_ENV=production
    depends_on:
EOF

    # Add dependencies
    local has_deps=false
    if [[ $add_postgres =~ ^[Yy]$ ]]; then
        echo "      - postgres" >> docker-compose.yml
        has_deps=true
    fi
    if [[ $add_redis =~ ^[Yy]$ ]]; then
        echo "      - redis" >> docker-compose.yml
        has_deps=true
    fi
    if [[ $add_mongo =~ ^[Yy]$ ]]; then
        echo "      - mongo" >> docker-compose.yml
        has_deps=true
    fi

    # If no dependencies, remove depends_on
    if [ "$has_deps" = false ]; then
        # Remove the depends_on line
        sed -i '$ d' docker-compose.yml
    fi

    # Add networks and volumes
    cat >> docker-compose.yml << 'EOF'
    networks:
      - app-network
    volumes:
      - ./:/app
      - /app/node_modules
EOF

    # Add PostgreSQL if requested
    if [[ $add_postgres =~ ^[Yy]$ ]]; then
        cat >> docker-compose.yml << 'EOF'

  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: app_db
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - app-network
    ports:
      - "5432:5432"
EOF
    fi

    # Add Redis if requested
    if [[ $add_redis =~ ^[Yy]$ ]]; then
        cat >> docker-compose.yml << 'EOF'

  redis:
    image: redis:7-alpine
    networks:
      - app-network
    ports:
      - "6379:6379"
EOF
    fi

    # Add MongoDB if requested
    if [[ $add_mongo =~ ^[Yy]$ ]]; then
        cat >> docker-compose.yml << 'EOF'

  mongo:
    image: mongo:7
    environment:
      MONGO_INITDB_ROOT_USERNAME: mongo
      MONGO_INITDB_ROOT_PASSWORD: mongo
    volumes:
      - mongo-data:/data/db
    networks:
      - app-network
    ports:
      - "27017:27017"
EOF
    fi

    # Add networks section
    cat >> docker-compose.yml << 'EOF'

networks:
  app-network:
    driver: bridge

EOF

    # Add volumes section if needed
    if [[ $add_postgres =~ ^[Yy]$ ]] || [[ $add_mongo =~ ^[Yy]$ ]]; then
        echo "volumes:" >> docker-compose.yml
        if [[ $add_postgres =~ ^[Yy]$ ]]; then
            echo "  postgres-data:" >> docker-compose.yml
        fi
        if [[ $add_mongo =~ ^[Yy]$ ]]; then
            echo "  mongo-data:" >> docker-compose.yml
        fi
    fi

    echo -e "${GREEN}   ✓ docker-compose.yml created${NC}"
    echo ""
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ File generated successfully!${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "  • Review docker-compose.yml"
    echo "  • Start services: $RUNTIME-compose up -d"
    echo "  • View logs: $RUNTIME-compose logs -f"
    echo "  • Stop services: $RUNTIME-compose down"
    echo ""
    read -p "Press Enter to continue..."
}

show_project_info() {
    show_header
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  Project Information${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo ""

    detect_project_type

    echo ""
    echo -e "${BLUE}Project Type:${NC} $PROJECT_TYPE"
    echo -e "${BLUE}Current Directory:${NC} $(pwd)"
    echo -e "${BLUE}Container Runtime:${NC} $RUNTIME_NAME"
    echo -e "${BLUE}Build Tool:${NC} $BUILD_TOOL_NAME"

    echo ""
    echo -e "${CYAN}Files in current directory:${NC}"
    ls -la | head -n 15

    echo ""
    read -p "Press Enter to continue..."
}

# ============================================================================
# MAIN PROGRAM
# ============================================================================

main() {
    # Detect runtime on startup
    detect_runtime
    check_runtime_installed

    # Main menu loop
    while true; do
        show_menu

        read -p "Enter your choice (1-5): " choice
        echo ""

        case $choice in
            1)
                create_dockerfile
                ;;
            2)
                build_and_test
                ;;
            3)
                generate_compose
                ;;
            4)
                show_project_info
                ;;
            5)
                echo -e "${GREEN}👋 Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Invalid choice. Please enter 1-5.${NC}"
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

# Run main program
main
