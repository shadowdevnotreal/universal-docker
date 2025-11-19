# Advanced Configuration

Customization options and advanced settings.

---

## Custom Docker Compose Version

### Specify Exact Version

**Edit before running:**
```bash
# In install-docker-linux.sh
DOCKER_COMPOSE_VERSION="v2.20.0"  # Specific version
```

### Skip Version Detection

**Force a specific version:**
```bash
# Comment out GitHub API call
# Use hardcoded version
DOCKER_COMPOSE_VERSION="v2.24.5"
```

---

## Checksum Verification

### Skip Verification (Not Recommended)

**If absolutely necessary:**
```bash
# Comment out verification block in install-docker-linux.sh
# Lines containing SHA256 verification
```

**Warning:** This reduces security. Only do this if:
- You're in a trusted environment
- GitHub is blocking your requests
- You understand the risks

---

## Podman Configuration

### Rootless Mode

**Enable after installation:**
```bash
# Allow user namespaces
sudo sysctl -w user.max_user_namespaces=28633

# Make persistent
echo "user.max_user_namespaces=28633" | sudo tee -a /etc/sysctl.conf

# Test rootless
podman run --rm hello-world
```

### Storage Configuration

**Edit storage config:**
```bash
# Edit ~/.config/containers/storage.conf
mkdir -p ~/.config/containers

cat > ~/.config/containers/storage.conf << EOF
[storage]
driver = "overlay"
runroot = "/run/user/$(id -u)/containers"
graphroot = "$HOME/.local/share/containers/storage"

[storage.options.overlay]
mountopt = "nodev"
EOF
```

### Registry Configuration

**Add custom registries:**
```bash
# Edit ~/.config/containers/registries.conf
mkdir -p ~/.config/containers

cat > ~/.config/containers/registries.conf << EOF
[registries.search]
registries = ['docker.io', 'quay.io', 'your-registry.com']

[registries.insecure]
registries = ['localhost:5000']
EOF
```

---

## Docker Configuration

### Daemon Settings

**Edit `/etc/docker/daemon.json`:**
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "dns": ["8.8.8.8", "8.8.4.4"],
  "storage-driver": "overlay2"
}
```

**Apply changes:**
```bash
sudo systemctl restart docker
```

### Default Resource Limits

**Add to daemon.json:**
```json
{
  "default-ulimits": {
    "nofile": {
      "Name": "nofile",
      "Hard": 64000,
      "Soft": 64000
    }
  }
}
```

---

## Docker Desktop Configuration

### Resource Limits (macOS/Windows)

**Via GUI:**
1. Open Docker Desktop
2. Settings → Resources
3. Adjust:
   - **CPUs:** Number of cores (default: 2)
   - **Memory:** RAM allocation (default: 2GB)
   - **Swap:** Swap file size (default: 1GB)
   - **Disk:** Image storage size (default: 64GB)

**Recommended for development:**
- CPUs: Half of available cores
- Memory: 4-8GB
- Swap: 2GB

### Network Settings

**Via GUI:**
1. Docker Desktop → Settings → Resources → Network
2. Configure:
   - Subnet
   - Subnet mask
   - Gateway

**Or edit daemon.json:**
```json
{
  "bip": "192.168.1.1/24",
  "default-address-pools": [
    {
      "base": "192.168.2.0/16",
      "size": 24
    }
  ]
}
```

---

## Container Manager Customization

### Change Default Colors

**Edit docker-manager.sh:**
```bash
# Find color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'

# Change to your preference
# Example: Bright green
GREEN='\033[1;32m'
```

### Add Custom Menu Options

**Example: Add "View Logs" option:**

```bash
# Add to show_menu() function
echo "  12. View container logs"

# Add to case statement
12)
    read -p "Enter container name: " container_name
    $RUNTIME logs "$container_name"
    read -p "Press Enter to continue..."
    ;;
```

### Disable Confirmations

**For experienced users:**
```bash
# Find confirmation prompts
read -p "Are you sure? (y/n): " confirm

# Comment out or skip:
# confirm="y"  # Auto-confirm
```

---

## Proxy Configuration

### HTTP/HTTPS Proxy

**For Docker daemon:**
```bash
# Create systemd drop-in
sudo mkdir -p /etc/systemd/system/docker.service.d

# Create proxy config
sudo cat > /etc/systemd/system/docker.service.d/http-proxy.conf << EOF
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:80"
Environment="HTTPS_PROXY=https://proxy.example.com:443"
Environment="NO_PROXY=localhost,127.0.0.1"
EOF

# Reload and restart
sudo systemctl daemon-reload
sudo systemctl restart docker
```

**For containers:**
```bash
docker run -e HTTP_PROXY=http://proxy.example.com:80 \
           -e HTTPS_PROXY=https://proxy.example.com:443 \
           myimage
```

---

## Logging Configuration

### Change Log Driver

**Available drivers:**
- `json-file` (default)
- `syslog`
- `journald`
- `gelf`
- `fluentd`

**Configure in daemon.json:**
```json
{
  "log-driver": "journald",
  "log-opts": {
    "tag": "docker/{{.Name}}"
  }
}
```

### Centralized Logging

**Example: Send to syslog:**
```json
{
  "log-driver": "syslog",
  "log-opts": {
    "syslog-address": "tcp://192.168.0.42:514",
    "tag": "docker/{{.Name}}"
  }
}
```

---

## Performance Tuning

### Disk Performance

**Use overlay2 storage driver:**
```json
{
  "storage-driver": "overlay2"
}
```

### Network Performance

**Increase MTU:**
```json
{
  "mtu": 1500
}
```

### Build Performance

**Enable BuildKit:**
```bash
export DOCKER_BUILDKIT=1
docker build .
```

**Or set in daemon.json:**
```json
{
  "features": {
    "buildkit": true
  }
}
```

---

## Security Hardening

### Enable User Namespace Remapping

```json
{
  "userns-remap": "default"
}
```

### Disable Legacy Registry

```json
{
  "disable-legacy-registry": true
}
```

### Enable Content Trust

```bash
export DOCKER_CONTENT_TRUST=1
docker pull image:tag
```

---

[⬅ Back to Home](Home)
