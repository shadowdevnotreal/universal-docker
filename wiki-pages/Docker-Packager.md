# Docker Packager

Interactive tool for packaging applications into Docker/Podman containers with zero Docker knowledge required.

---

## Overview

**docker-packager.sh** is an interactive tool that helps users create production-ready Dockerfiles, .dockerignore files, and docker-compose.yml configurations with best practices built-in.

### Key Features

✅ **Auto-detection** - Identifies project type automatically
✅ **Multi-stage builds** - Creates optimized, small images
✅ **Non-root users** - Secure by default (UID 1001)
✅ **Health checks** - Automatic container monitoring
✅ **Runtime agnostic** - Works with Docker, Podman, and Buildah
✅ **Prerequisites checking** - Validates all dependencies before running

---

## Quick Start

### Basic Usage

```bash
# Navigate to your project directory
cd my-project

# Run the packager
./docker-packager.sh

# Follow the interactive prompts
```

### Example Session

```
╔════════════════════════════════════════════════════════════╗
║         🐳 Docker/Podman Application Packager           ║
║                     Version 1.0.0                        ║
╚════════════════════════════════════════════════════════════╝

Runtime: Docker
Build Tool: Docker

══════════════════════════════════════════════════════════════
  What would you like to do?
══════════════════════════════════════════════════════════════

  1. 📦 Create Dockerfile (Interactive)
  2. 🏗️  Build & Test Container
  3. 📝 Generate Docker Compose
  4. ℹ️  Show Project Info
  5. ❌ Exit
```

---

## Supported Project Types

### Node.js

**Detection:** `package.json`

**Generated Dockerfile:**
- Multi-stage build
- Alpine Linux base (small size)
- `npm ci` for production dependencies
- Non-root user (appuser)
- Health check on exposed port
- Layer caching optimization

**Example:**
```dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .

FROM node:18-alpine
RUN addgroup -g 1001 appuser && \
    adduser -D -u 1001 -G appuser appuser
WORKDIR /app
COPY --from=builder --chown=appuser:appuser /app ./
USER appuser
EXPOSE 3000
HEALTHCHECK CMD node -e "require('http').get(...)"
CMD npm start
```

### Python

**Detection:** `requirements.txt`, `pyproject.toml`, or `setup.py`

**Generated Dockerfile:**
- Multi-stage build
- Python slim base
- pip install with --user flag
- Non-root user (appuser)
- Virtual environment support
- Health check

**Example:**
```dockerfile
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

FROM python:3.11-slim
RUN useradd -m -u 1001 appuser
WORKDIR /app
COPY --from=builder --chown=appuser:appuser /root/.local /home/appuser/.local
COPY --chown=appuser:appuser . .
ENV PATH=/home/appuser/.local/bin:$PATH
USER appuser
EXPOSE 8000
HEALTHCHECK CMD python -c "import urllib.request..."
CMD python app.py
```

### Go

**Detection:** `go.mod` or `go.sum`

**Generated Dockerfile:**
- Multi-stage build
- CGO_ENABLED=0 for static binary
- Alpine Linux (minimal size)
- Non-root user
- Health check with wget

**Example:**
```dockerfile
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o app .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
RUN addgroup -g 1001 appuser && \
    adduser -D -u 1001 -G appuser appuser
WORKDIR /app
COPY --from=builder --chown=appuser:appuser /app/app ./
USER appuser
EXPOSE 8080
HEALTHCHECK CMD wget --spider http://localhost:8080/ || exit 1
CMD ["./app"]
```

### Static Sites

**Detection:** `index.html` (without package.json)

**Generated Dockerfile:**
- nginx:alpine base
- Simple static file serving
- Health check

**Example:**
```dockerfile
FROM nginx:alpine
COPY . /usr/share/nginx/html
EXPOSE 80
HEALTHCHECK CMD wget --spider http://localhost/ || exit 1
```

---

## Menu Options

### Option 1: Create Dockerfile

**Interactive Flow:**

1. **Project Detection**
   - Auto-detects project type
   - Confirms with user
   - Allows manual selection if detection fails

2. **Configuration Questions**
   - Port number (with sensible defaults)
   - Entry command
   - Environment variables (optional)

3. **File Generation**
   - Creates `Dockerfile`
   - Creates `.dockerignore`
   - Checks for existing files (asks to overwrite)

4. **Output**
   - Success message
   - Next steps suggestion

**Generated Files:**

**.dockerignore** (language-specific):
```
# Node.js
node_modules
npm-debug.log
.git
.env
*.log
coverage
dist
build

# Python
__pycache__
*.pyc
venv/
.pytest_cache

# Go
vendor/
bin/
*.exe
*.test
```

### Option 2: Build & Test Container

**Flow:**

1. **Validation**
   - Checks for Dockerfile existence
   - Prompts to create if missing

2. **Image Naming**
   - Suggests name from directory
   - Asks for tag (default: latest)

3. **Build Process**
   - Uses detected runtime (Docker/Podman/Buildah)
   - Shows build output
   - Reports success/failure

4. **Test Run** (optional)
   - Asks to run container
   - Prompts for port mapping
   - Runs with `--rm` flag (auto-cleanup)
   - Shows logs in real-time

**Example:**
```bash
Image name? [my-app]:
Image tag? [latest]:

🏗️  Building image: my-app:latest

Using Docker for build...
✅ Image built successfully!

Would you like to test run the container? (y/n): y

Map to host port? (leave empty to skip): 3000
Container port? [3000]:

🚀 Running container...

Command: docker run --rm --name my-app-test -p 3000:3000 my-app:latest
Press Ctrl+C to stop the container

Server running at http://localhost:3000/
```

### Option 3: Generate Docker Compose

**Flow:**

1. **Prerequisites Check**
   - Verifies docker-compose/podman-compose installed
   - Offers to continue anyway if missing
   - Shows installation instructions

2. **Configuration**
   - Service name
   - Port mapping
   - Additional services selection:
     - PostgreSQL
     - Redis
     - MongoDB

3. **File Generation**
   - Creates `docker-compose.yml`
   - Configures networks
   - Sets up volumes
   - Includes environment variables

**Generated docker-compose.yml:**
```yaml
version: '3.8'

services:
  myapp:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    depends_on:
      - postgres
      - redis
    networks:
      - app-network

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

  redis:
    image: redis:7-alpine
    networks:
      - app-network
    ports:
      - "6379:6379"

networks:
  app-network:
    driver: bridge

volumes:
  postgres-data:
```

### Option 4: Show Project Info

**Displays:**
- Project type (detected)
- Current directory
- Container runtime
- Build tool
- List of files in directory

**Example:**
```
══════════════════════════════════════════════════════════════
  Project Information
══════════════════════════════════════════════════════════════

📁 Detecting project type...
   ✓ Detected: Node.js (found package.json)

Project Type: nodejs
Current Directory: /home/user/my-project
Container Runtime: Docker
Build Tool: Docker

Files in current directory:
drwxr-xr-x  5 user user  160 Nov 19 12:00 .
drwxr-xr-x 10 user user  320 Nov 19 11:00 ..
-rw-r--r--  1 user user  500 Nov 19 12:00 package.json
-rw-r--r--  1 user user 1200 Nov 19 12:00 index.js
drwxr-xr-x  3 user user   96 Nov 19 11:00 node_modules
```

---

## Prerequisites

### Required Dependencies

The packager automatically checks for and reports missing dependencies:

**Critical (script won't run without these):**
- `bash` - Shell interpreter
- `sed` - Text stream editor
- `grep` - Pattern matching
- `awk` - Text processing
- `basename` - Extract filename from path
- `pwd` - Print working directory

**Runtime (at least one required):**
- Docker
- Podman
- Buildah (optional, for Podman builds)

**Optional (for specific features):**
- `docker-compose` or `podman-compose` - For Option 3 (Generate Compose)

### Installation Instructions

If dependencies are missing, the tool shows:

**Ubuntu/Debian:**
```bash
sudo apt-get install sed grep gawk coreutils
```

**macOS:**
```bash
brew install coreutils
```

**Docker Compose:**
```bash
# For Docker
sudo apt-get install docker-compose

# For Podman
pip3 install podman-compose
```

---

## Runtime Detection

The packager supports multiple container runtimes and automatically adapts.

### Detection Logic

```bash
detect_runtime() {
    if command -v docker &> /dev/null; then
        RUNTIME="docker"
        BUILD_TOOL="docker"
    elif command -v podman &> /dev/null; then
        RUNTIME="podman"
        if command -v buildah &> /dev/null; then
            BUILD_TOOL="buildah"  # Preferred for Podman
        else
            BUILD_TOOL="podman"
        fi
    else
        RUNTIME="none"
    fi
}
```

### Build Commands

| Runtime | Build Command | Run Command |
|---------|---------------|-------------|
| Docker | `docker build -t IMAGE .` | `docker run --rm -p PORT:PORT IMAGE` |
| Podman | `podman build -t IMAGE .` | `podman run --rm -p PORT:PORT IMAGE` |
| Buildah | `buildah bud -t IMAGE .` | (uses podman for run) |

---

## Best Practices Implemented

### 1. Multi-Stage Builds

**Benefit:** 50-80% smaller images

**Pattern:**
```dockerfile
# Build stage - contains build tools
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Production stage - minimal dependencies
FROM node:18-alpine
COPY --from=builder /app ./
```

### 2. Non-Root Users

**Benefit:** Security, compliance

**Implementation:**
```dockerfile
# Alpine Linux (Node.js, Go)
RUN addgroup -g 1001 appuser && \
    adduser -D -u 1001 -G appuser appuser

# Debian/Ubuntu (Python)
RUN useradd -m -u 1001 appuser

USER appuser
```

### 3. Health Checks

**Benefit:** Container orchestration, automatic restart

**Patterns:**
```dockerfile
# HTTP check (Node.js)
HEALTHCHECK CMD node -e "require('http').get('http://localhost:3000/', ...)"

# HTTP check (Python)
HEALTHCHECK CMD python -c "import urllib.request; ..."

# HTTP check (Go, Static)
HEALTHCHECK CMD wget --spider http://localhost:8080/ || exit 1
```

### 4. Layer Caching

**Benefit:** Faster rebuilds

**Order:**
1. Dependency files (changes rarely)
2. Install dependencies
3. Source code (changes frequently)
4. Build application

### 5. .dockerignore

**Benefit:** Smaller build context, faster builds, no secrets leaked

**Critical patterns:**
- `.git/`
- `.env`
- `node_modules/` (for Node.js)
- `__pycache__/` (for Python)
- `*.log`

---

## Error Handling

### No Runtime Found

```
❌ Error: No container runtime found!

Please install Docker or Podman first:
  • Run: ./universal-installer.sh
  • Or visit: https://github.com/shadowdevnotreal/universal-docker
```

### Missing Dependencies

```
❌ Missing required dependencies:
  • sed
  • grep

Please install missing dependencies using your package manager:
  • Ubuntu/Debian: sudo apt-get install sed grep
  • macOS: brew install coreutils
```

### No Dockerfile for Build

```
❌ No Dockerfile found in current directory

Please create a Dockerfile first (Option 1)
```

### Compose Not Available

```
⚠️  docker-compose/podman-compose not found

To use this feature, install:
  • Docker Compose: sudo apt-get install docker-compose
  • Or use Docker Compose v2: already bundled with Docker Desktop

You can still create docker-compose.yml manually, but you won't be able to run it.

Continue anyway? (y/n):
```

---

## Advanced Usage

### Custom Port Mapping

When testing containers, you can map any host port to container port:

```
Map to host port? [leave empty to skip]: 8080
Container port? [3000]: 3000
```

This allows running multiple containers simultaneously without port conflicts.

### Environment Variables

While the base Dockerfile includes common environment variables, you can customize them at runtime:

```bash
docker run -e NODE_ENV=development -e DEBUG=true myapp:latest
```

Or in docker-compose.yml:
```yaml
services:
  myapp:
    environment:
      - NODE_ENV=development
      - DEBUG=true
      - DATABASE_URL=postgres://...
```

### Multi-Container Development

Use docker-compose for full development environments:

```bash
# Generate compose file with all services
./docker-packager.sh
# Select Option 3
# Choose PostgreSQL, Redis

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

---

## Troubleshooting

### Build Fails

**Check:**
1. Dockerfile syntax is valid
2. All files referenced by COPY exist
3. Sufficient disk space
4. Internet connection (for pulling base images)

**Debug:**
```bash
# Build with verbose output
docker build -t myapp:latest --progress=plain .
```

### Container Exits Immediately

**Check:**
1. CMD/ENTRYPOINT is correct
2. Application doesn't have errors
3. Required files are present

**Debug:**
```bash
# Run interactively
docker run -it myapp:latest /bin/sh

# View logs
docker logs myapp-test
```

### Permission Denied

**Cause:** Non-root user can't access files

**Fix:** Ensure COPY uses --chown:
```dockerfile
COPY --chown=appuser:appuser . .
```

---

## Version History

### v1.0.0 (2025-11-19)

**Features:**
- Interactive Dockerfile generation
- Multi-stage builds for Node.js, Python, Go
- Static site support (nginx)
- .dockerignore generation
- Docker Compose generation
- Build and test workflow
- Runtime detection (Docker/Podman/Buildah)
- Prerequisites checking
- Non-root users by default
- Health checks
- Layer optimization

**Languages Supported:**
- Node.js
- Python
- Go
- Static HTML/CSS/JS

**Stats:**
- 969 lines of code
- 17 functions
- Multi-agent COT methodology

---

## Future Roadmap (v2.0)

**Planned Features:**
- Java support (Spring Boot, Maven/Gradle)
- PHP support (Composer, Laravel)
- Ruby support (Bundler, Rails)
- Framework detection (Express, Django, Gin)
- Registry push functionality
- Integration with docker-manager.sh
- Environment variable templates
- Kubernetes YAML generation
- Multi-architecture builds
- Security scanning integration

---

[⬅ Back to Home](Home)
