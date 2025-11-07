# Troubleshooting

Common issues and their solutions.

---

## Docker Daemon Issues

### Issue: "Docker daemon is not running"

**Symptoms:**
```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock
```

**Solutions:**

**Linux:**
```bash
sudo systemctl start docker
sudo systemctl enable docker  # Auto-start on boot
```

**macOS:**
```bash
open -a Docker
# Wait 30-60 seconds for startup
```

**Verification:**
```bash
docker info
```

---

## Permission Issues

### Issue: "Permission denied" (Linux)

**Symptoms:**
```
Got permission denied while trying to connect to the Docker daemon socket
```

**Solution:**
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Log out and back in (or reboot)

# Verify
groups | grep docker
```

**Alternative (temporary):**
```bash
# Use sudo for individual commands
sudo docker ps
```

---

## API Rate Limiting

### Issue: GitHub API rate limiting

**Symptoms:**
```
Note: Could not fetch latest version from GitHub API
Using fallback version: v2.24.5
```

**Explanation:**
- GitHub limits unauthenticated API requests to 60/hour
- Not an error - fallback version is recent and functional

**Solution (Optional):**
```bash
# Use authenticated requests (higher limit)
curl -H "Authorization: token YOUR_GITHUB_TOKEN" \
  https://api.github.com/repos/docker/compose/releases/latest
```

---

## macOS Installation Issues

### Issue: DMG mount failure

**Symptoms:**
```
ERROR: Failed to mount Docker.dmg
```

**Possible Causes:**
1. Another "Docker" volume already mounted
2. Corrupted download
3. Insufficient disk space

**Solutions:**
```bash
# Unmount existing
hdiutil detach /Volumes/Docker

# Check disk space
df -h

# Re-download
rm ~/Downloads/Docker.dmg
# Run installer again
```

### Issue: macOS version too old

**Symptoms:**
```
ERROR: This script requires macOS 10.14 (Mojave) or newer
```

**Solution:**
- Upgrade macOS to 10.14 or newer
- Or use Docker Toolbox (legacy, not recommended)

---

## Linux-Specific Issues

### Issue: Podman alias not working

**Symptoms:**
```bash
docker: command not found
# But podman works
```

**Solution:**
```bash
# Restart terminal or
source ~/.bashrc

# Verify alias
alias docker
# Should show: alias docker='podman'
```

### Issue: systemctl not found

**Symptoms:**
```
systemctl: command not found
```

**Explanation:**
- System doesn't use systemd
- May be using init.d, upstart, or another init system

**Solution:**
```bash
# Check init system
ps -p 1

# For init.d
sudo service docker start

# For upstart
sudo start docker
```

---

## Windows-Specific Issues

### Issue: WSL 2 not enabled

**Symptoms:**
```
WSL 2 installation is incomplete
```

**Solution:**
```powershell
# Enable WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Enable Virtual Machine Platform
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Restart computer
# Set WSL 2 as default
wsl --set-default-version 2
```

### Issue: Virtualization not enabled

**Symptoms:**
```
Hardware assisted virtualization and data execution protection must be enabled in the BIOS
```

**Solution:**
1. Restart computer
2. Enter BIOS/UEFI (usually F2, F10, Del, or Esc during boot)
3. Find "Virtualization Technology" or "Intel VT-x" or "AMD-V"
4. Enable it
5. Save and exit

---

## Container Issues

### Issue: Cannot pull images

**Symptoms:**
```
Error response from daemon: Get https://registry-1.docker.io/v2/: dial tcp: lookup registry-1.docker.io: no such host
```

**Solutions:**
```bash
# Check internet connection
ping 8.8.8.8

# Check DNS resolution
nslookup registry-1.docker.io

# Try different DNS (Google DNS)
# Add to /etc/docker/daemon.json:
{
  "dns": ["8.8.8.8", "8.8.4.4"]
}

# Restart Docker
sudo systemctl restart docker
```

### Issue: Container exits immediately

**Symptoms:**
```bash
docker run myimage
# Container exits with code 0 or 1
```

**Troubleshooting:**
```bash
# View logs
docker logs <container_name>

# Run interactively
docker run -it myimage /bin/bash

# Check exit code
docker ps -a
# Look at STATUS column
```

---

## Diagnostic Commands

### Check Docker Installation

```bash
# Version info
docker --version
docker-compose --version

# System info
docker info

# Test run
docker run hello-world
```

### Check Podman Installation

```bash
# Version info
podman --version
podman-compose --version

# System info
podman info

# Test run
podman run hello-world
```

### System Resources

```bash
# Disk usage
docker system df
# or
podman system df

# Clean up
docker system prune
# or
podman system prune
```

---

## Getting Help

If your issue isn't covered here:

1. **Check logs:**
   - Linux: `journalctl -u docker`
   - macOS: Docker Desktop → Troubleshoot → Show logs
   - Windows: Docker Desktop → Troubleshoot → Show logs

2. **Search existing issues:**
   - [Docker GitHub Issues](https://github.com/docker/docker-ce/issues)
   - [Podman GitHub Issues](https://github.com/containers/podman/issues)
   - [Our Issues](https://github.com/shadowdevnotreal/universal-docker/issues)

3. **Create new issue:**
   - Include OS version
   - Include error messages
   - Include relevant logs
   - Describe steps to reproduce

---

[⬅ Back to Home](Home)
