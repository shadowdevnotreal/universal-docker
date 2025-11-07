# Script Specifications

Technical specifications for error handling, logging, and coding conventions.

---

## Error Handling

All Bash scripts use:
```bash
set -euo pipefail
```

**Meaning:**
- `set -e`: Exit immediately if any command fails
- `set -u`: Treat unset variables as errors
- `set -o pipefail`: Pipe failures propagate

**Example:**
```bash
#!/bin/bash
set -euo pipefail

# This will exit if curl fails
curl -fsSL https://example.com/file.sh | sh

# This will exit if MYVAR is unset
echo "$MYVAR"

# This will exit if grep fails in the pipe
cat file.txt | grep "pattern" | wc -l
```

---

## Logging

### Output Levels

- ✓ **Success indicators** (green checkmarks)
- ⚠️ **Warnings** (yellow text)
- ❌ **Errors** (red text)
- ℹ️ **Information** (blue text)

**Example:**
```bash
echo "✓ Docker Engine installed"
echo "WARNING: Could not verify checksum"
echo "ERROR: Failed to download"
```

### Color Codes

```bash
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'  # No Color (reset)
```

**Usage:**
```bash
echo -e "${GREEN}✓ Success${NC}"
echo -e "${YELLOW}⚠ Warning${NC}"
echo -e "${RED}❌ Error${NC}"
```

---

## User Interactions

### Confirmation Prompts

```bash
read -p "Do you want to continue? (y/n): " response
case $response in
    [Yy]*) proceed ;;
    *) abort ;;
esac
```

### Pause Points

```bash
read -p "Press Enter to continue or Ctrl+C to cancel..."
```

### Choice Menus

```bash
echo "Choose your option:"
echo "  1. Option One"
echo "  2. Option Two"
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1) option_one ;;
    2) option_two ;;
    *) echo "Invalid choice" ;;
esac
```

---

## Code Style

### Bash

- **Naming:** Use `snake_case` for function names
- **Indentation:** 4 spaces
- **Comments:** Explain complex logic
- **Error handling:** Always use `set -euo pipefail`
- **Variables:** Always quote: `"$VARIABLE"`

**Example:**
```bash
#!/bin/bash
set -euo pipefail

# Function to install Docker
install_docker() {
    local DOCKER_VERSION="$1"

    echo "Installing Docker ${DOCKER_VERSION}..."

    # Download and execute installation script
    curl -fsSL https://get.docker.com | sh

    echo "✓ Docker installed successfully"
}

# Main execution
install_docker "latest"
```

### PowerShell

- **Naming:** Use `PascalCase` for functions
- **Indentation:** 4 spaces
- **Comments:** Explain cmdlet usage
- **Verbs:** Use approved verbs (Get-, Set-, New-, etc.)

**Example:**
```powershell
function Install-Docker {
    param (
        [string]$Version = "latest"
    )

    Write-Host "Installing Docker $Version..." -ForegroundColor Cyan

    # Download installer
    $installerPath = "$env:USERPROFILE\Downloads\DockerDesktopInstaller.exe"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath

    Write-Host "✓ Docker installer downloaded" -ForegroundColor Green
}

# Main execution
Install-Docker
```

---

## Testing Conventions

### Manual Testing Checklist

- [ ] Fresh Ubuntu 22.04 VM
- [ ] Fresh macOS 13+ VM
- [ ] Fresh Windows 10/11 VM
- [ ] Existing Docker installation scenario
- [ ] Network failure scenarios
- [ ] Podman installation (Linux)
- [ ] Container Manager on Docker
- [ ] Container Manager on Podman

### Debug Mode

**Enable verbose output:**

**Bash scripts:**
```bash
bash -x install-docker-linux.sh
```

**PowerShell:**
```powershell
Set-PSDebug -Trace 1
.\install-docker-windows.ps1
```

---

[⬅ Back to Home](Home)
