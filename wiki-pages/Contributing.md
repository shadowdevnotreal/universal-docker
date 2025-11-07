# Contributing

Guidelines for contributing to the Universal Docker Installer project.

---

## Development Setup

### Prerequisites

- **Bash 4.0+** for shell scripts
- **PowerShell 5.1+** for Windows script
- **shellcheck** (optional but recommended) for linting
- **Git** for version control

### Clone and Setup

```bash
git clone https://github.com/shadowdevnotreal/universal-docker.git
cd universal-docker

# Make scripts executable
chmod +x *.sh

# Run shellcheck (if available)
shellcheck *.sh
```

---

## Code Style

### Bash Scripts

**Conventions:**
- Use `snake_case` for function names
- 4-space indentation
- Comment complex logic
- Use `set -euo pipefail`
- Quote variables: `"$VARIABLE"`
- Use descriptive variable names

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

### PowerShell Scripts

**Conventions:**
- Use `PascalCase` for functions
- 4-space indentation
- Comment cmdlet usage
- Use approved verbs (Get-, Set-, New-, etc.)
- Use parameter validation

**Example:**
```powershell
function Install-Docker {
    param (
        [Parameter(Mandatory=$false)]
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

## Testing

### Manual Testing Checklist

Before submitting a pull request, test on:

- [ ] **Fresh Ubuntu 22.04 VM**
- [ ] **Fresh macOS 13+ VM** (Intel and Apple Silicon if possible)
- [ ] **Fresh Windows 10/11 VM**
- [ ] **System with existing Docker installation**
- [ ] **Network failure scenarios** (unplug network during install)
- [ ] **Podman installation** (Linux)
- [ ] **Container Manager with Docker**
- [ ] **Container Manager with Podman**

### Test Cases

**Installation:**
- Fresh installation
- Upgrade existing installation
- Installation with network interruption
- Installation on slow network

**Container Manager:**
- All menu options
- Docker and Podman modes
- Error handling (e.g., no containers)
- Platform-specific commands

### Debug Mode

**Enable verbose output:**

**Bash:**
```bash
bash -x install-docker-linux.sh
```

**PowerShell:**
```powershell
Set-PSDebug -Trace 1
.\install-docker-windows.ps1
```

---

## Commit Message Format

Use clear, descriptive commit messages:

```
[Component] Brief description

Detailed explanation of changes:
- What was changed
- Why it was changed
- Any breaking changes

Fixes #issue_number
```

**Example:**
```
[install-linux] Add Podman support

Added interactive choice between Docker and Podman during installation.
Includes automatic alias setup for Docker compatibility.

Changes:
- New function: install_podman()
- Docker compatibility aliases in ~/.bashrc
- podman-compose installation via pip3

Fixes #42
```

**Component prefixes:**
- `[install-linux]` - Linux installer
- `[install-mac]` - macOS installer
- `[install-windows]` - Windows installer
- `[manager]` - Container manager
- `[docs]` - Documentation
- `[security]` - Security-related changes

---

## Pull Request Process

### Steps

1. **Fork** the repository
2. **Create** feature branch: `git checkout -b feature/amazing-feature`
3. **Commit** changes with clear messages
4. **Test** thoroughly on target platforms
5. **Push** to branch: `git push origin feature/amazing-feature`
6. **Open** Pull Request with description
7. **Address** review feedback

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix (non-breaking change fixing an issue)
- [ ] New feature (non-breaking change adding functionality)
- [ ] Breaking change (fix or feature causing existing functionality to change)
- [ ] Documentation update

## Testing
- [ ] Tested on Linux (Ubuntu/Debian)
- [ ] Tested on macOS
- [ ] Tested on Windows
- [ ] Tested with existing installations
- [ ] Tested error scenarios

## Checklist
- [ ] Code follows project style guidelines
- [ ] Comments added for complex logic
- [ ] Documentation updated (README, Wiki, etc.)
- [ ] No breaking changes (or documented if necessary)
- [ ] All tests pass
```

---

## Development Philosophy

### Code With Purpose

**Principles:**
1. **Keep it lean** - Don't add unnecessary features
2. **User responsibility** - Put appropriate responsibility on users
3. **Fail fast** - Use `set -euo pipefail` for early error detection
4. **Clear feedback** - Provide helpful error messages
5. **Security first** - Always verify downloads when possible

**What to avoid:**
- "Go get some coffee" scripts (overly automated)
- Excessive hand-holding
- Unnecessary abstractions
- Feature creep

### When to Add Features

**Add features if they:**
- Solve a common problem
- Improve security
- Enhance clarity for beginners
- Fix platform-specific issues

**Don't add features if they:**
- Only benefit edge cases
- Complicate the codebase
- Duplicate existing functionality
- Require excessive maintenance

---

## Code Review Guidelines

### For Reviewers

**Check for:**
- [ ] Code follows style guidelines
- [ ] Error handling is appropriate
- [ ] Security implications are considered
- [ ] Documentation is updated
- [ ] Commit messages are clear
- [ ] Tests are included/updated

**Provide feedback:**
- Be constructive and specific
- Suggest improvements, don't just criticize
- Explain the "why" behind suggestions
- Acknowledge good practices

### For Contributors

**When receiving feedback:**
- Be open to suggestions
- Ask questions if unclear
- Make requested changes promptly
- Thank reviewers for their time

---

## Issue Reporting

### Bug Reports

**Include:**
- OS and version
- Docker/Podman version (if applicable)
- Exact error message
- Steps to reproduce
- Expected vs actual behavior

**Example:**
```markdown
**Environment:**
- OS: Ubuntu 22.04 LTS
- Script: install-docker-linux.sh
- Version: v1.0.0

**Steps to reproduce:**
1. Run ./install-docker-linux.sh
2. Choose option 1 (Docker Engine)
3. Wait for Docker Compose installation

**Expected:** SHA256 verification passes
**Actual:** Verification fails with "checksum mismatch"

**Error message:**
```
WARNING: Checksum mismatch!
Expected: abc123...
Actual: def456...
```
```

### Feature Requests

**Include:**
- Clear description of feature
- Use case / problem it solves
- Suggested implementation (optional)
- Alternatives considered

---

## Documentation

### When to Update Documentation

**Update docs when:**
- Adding new features
- Changing existing behavior
- Fixing bugs with user-visible impact
- Adding configuration options

**Which docs to update:**
- **README.md** - For user-facing changes
- **Wiki** - For technical details
- **TODO.md** - For roadmap changes
- **Code comments** - For implementation details

### Documentation Style

**README:**
- Simple language
- Examples and screenshots
- FAQs for common questions
- Links to Wiki for details

**Wiki:**
- Technical accuracy
- Code examples
- Architecture diagrams
- Troubleshooting steps

---

## Getting Help

**Resources:**
- [GitHub Issues](https://github.com/shadowdevnotreal/universal-docker/issues)
- [GitHub Discussions](https://github.com/shadowdevnotreal/universal-docker/discussions)
- [Docker Documentation](https://docs.docker.com/)
- [Podman Documentation](https://docs.podman.io/)

**Before asking:**
1. Search existing issues
2. Check documentation
3. Try debugging yourself
4. Prepare a minimal reproducible example

---

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

[⬅ Back to Home](Home)
