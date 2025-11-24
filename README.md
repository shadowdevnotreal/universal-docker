<div align="center">

![Universal-docker](https://github.com/user-attachments/assets/a34aa24d-a1bf-4d30-a3cb-2379c04b5794)


# 🐳 Universal Docker

### Complete Docker/Podman toolkit: Install, Manage, Package & Uninstall

[![GitHub stars](https://img.shields.io/github/stars/shadowdevnotreal/universal-docker?style=social)](https://github.com/shadowdevnotreal/universal-docker/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/shadowdevnotreal/universal-docker?style=social)](https://github.com/shadowdevnotreal/universal-docker/network/members)
[![GitHub watchers](https://img.shields.io/github/watchers/shadowdevnotreal/universal-docker?style=social)](https://github.com/shadowdevnotreal/universal-docker/watchers)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20Windows-blue)](https://github.com/shadowdevnotreal/universal-docker)
[![Shell Script](https://img.shields.io/badge/Shell_Script-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://docs.microsoft.com/en-us/powershell/)

[Get Started](#-quick-start) • [Three Tools](#-what-you-get) • [Wiki](WIKI.md) • [Support](#-support)

</div>

---

## ⚡ Why Universal Docker?

<div align="center">

🎯 **Install Docker OR Podman in one command** - No confusing steps, no tech knowledge needed
🐳 **100% Universal** - All tools work with Docker AND Podman seamlessly
📦 **Turn your app into a container** - Auto-generate production-ready Dockerfiles
🎨 **Manage containers with menus** - No commands to memorize, just pick numbers
🔒 **Secure by default** - Best practices built into everything
🚀 **Cross-platform** - Works on Linux, macOS, and Windows

</div>

---

## 🎯 What Is This?

Installing Docker or Podman can be confusing. Multiple operating systems, different installation methods, complicated commands... 😰

**This tool makes it easy!** Just run one script, and you're ready to go. No tech knowledge required.

### Perfect For:
- 👶 **Beginners** who want to learn containers
- 💼 **Developers** who need a quick setup
- 🎓 **Students** working on projects
- 🏢 **Teams** who want consistent environments

---

## 📁 What's Included

This repository contains everything you need:

**🚀 Universal Starters (Main Entry Points):**
- `universal-docker.sh` - Interactive menu for Linux & macOS
- `universal-docker.bat` - Interactive menu for Windows

**🛠️ Installation Scripts:**
- `universal-installer.sh` - Detects OS and routes to correct installer
- `install-docker-linux.sh` - Linux installer (Docker or Podman)
- `install-docker-mac.sh` - macOS installer (Docker or Podman)
- `install-docker-windows.ps1` - Windows installer (Docker or Podman Desktop)

**🎨 Management Tools:**
- `docker-manager.sh` - Container management with menus (Docker & Podman)
- `docker-packager.sh` - Auto-generate Dockerfiles (Docker & Podman)
- `universal-uninstaller.sh` - Clean removal tool (Docker & Podman)

**📚 Documentation:**
- `README.md` - Complete user guide (this file)
- `WIKI.md` - Technical details and troubleshooting
- `LICENSE` - MIT License

All tools work with **both Docker and Podman** on **all platforms**!

---

## ✨ Complete Toolkit

<div align="center">

| 🚀 Universal Starter | 🤖 Installer | 🎨 Manager | 📦 Packager | 🗑️ Uninstaller |
|:---:|:---:|:---:|:---:|:---:|
| **One menu for all** | **Setup** | **Control** | **Build** | **Remove** |
| Launch everything | Docker/Podman | Containers | Dockerfiles | Clean uninstall |
| Main entry point | Installation | Management | Packaging | Removal |
| `.sh` (Linux/Mac)<br>`.bat` (Windows) | Auto-launched | Auto-launched | Auto-launched | Auto-launched |

</div>

> 💡 **New!** Use `./universal-docker.sh` (Linux/Mac) or `universal-docker.bat` (Windows) to access all tools from one place!

---

### 🤖 Tool 1: Universal Installer

**The Problem:** Installing Docker or Podman is confusing - different steps for each OS, complicated commands, unclear errors.

**The Solution:** One script that handles everything for you - with full choice!

```bash
# Linux & Mac
./universal-installer.sh

# Windows (PowerShell Admin)
.\install-docker-windows.ps1
```

**What It Does:**
- ✅ Detects your operating system automatically
- ✅ **Choice:** Install Docker OR Podman (on ALL platforms!)
- ✅ Verifies installation works correctly
- ✅ Sets up everything needed to run containers
- ✅ Shows clear progress messages

**Runtime Options:**
- **Linux:** Docker Engine OR Podman (native)
- **macOS:** Docker Desktop OR Podman (via Homebrew)
- **Windows:** Docker Desktop OR Podman Desktop (via winget)

**Platforms:** Linux ✅ | macOS ✅ | Windows ✅

---

### 🎨 Tool 2: Container Manager

**The Problem:** Docker/Podman CLI commands are hard to remember - `docker ps -a`, `docker system prune -a`, etc.

**The Solution:** A beautiful interactive menu - just pick numbers! **Works with Docker AND Podman.**

```
═══════════════════════════════════════════
   🐳 Container Manager - Easy Mode
═══════════════════════════════════════════

● Docker is running
📊 Running containers: 2

What would you like to do?

  1. 📊 Check status
  2. ▶️  Start Docker
  3. ⏹️  Stop Docker
  4. 📋 List containers
  5. 🧹 Cleanup unused data
  6. 📝 View logs
  7. ❌ Exit
```

**What It Does:**
- ✅ **Auto-detects** Docker or Podman (or both!)
- ✅ Check runtime status
- ✅ Start/stop container runtime
- ✅ List and manage containers
- ✅ View container logs
- ✅ Free up disk space
- ✅ No commands to memorize!

**100% Universal:** Works identically with Docker AND Podman

---

### 📦 Tool 3: Application Packager **NEW!**

**The Problem:** Creating Dockerfiles requires container expertise - base images, multi-stage builds, security hardening...

**The Solution:** Auto-generate production-ready Dockerfiles with best practices built-in! **Works with Docker AND Podman.**

```
═══════════════════════════════════════════
   📦 Docker/Podman Application Packager
═══════════════════════════════════════════

✓ Detected: Node.js (found package.json)

What would you like to do?

  1. 📝 Create Dockerfile (Interactive)
  2. 🏗️  Build & Test Container
  3. 📋 Generate Docker Compose
  4. ℹ️  Show Project Info
  5. ❌ Exit
```

**What It Does:**
- 🎯 **Auto-detects** project type (Node.js, Python, Go, Static HTML)
- 📝 **Generates Dockerfile** - Multi-stage builds, non-root users, health checks
- 📄 **Creates .dockerignore** - Keeps secrets and junk out of your images
- 🏗️ **Builds & tests** - One command to containerize your app
- 📋 **Docker Compose** - Add PostgreSQL, Redis, MongoDB with one click
- 🐳 **100% Universal** - Auto-detects Docker or Podman, works with both
- 💨 **Tiny images** - 50-80% smaller with multi-stage builds
- 🔒 **Secure by default** - Non-root users (UID 1001), security best practices

**Quick Example:**
```bash
cd my-nodejs-app
./docker-packager.sh
# Select 1: Create Dockerfile
# Answer 2 questions (port, entry command)
# Done! Production-ready Dockerfile created
```

**Supported Languages:**
- **Node.js** - Detects `package.json`, uses Alpine Linux, npm ci
- **Python** - Detects `requirements.txt`, uses slim images, pip install
- **Go** - Detects `go.mod`, creates tiny static binaries
- **Static Sites** - Detects `index.html`, uses nginx

---

### 🗑️ Tool 4: Universal Uninstaller **NEW!**

**The Problem:** Removing Docker/Podman completely is tricky - leftover files, configs, and images everywhere.

**The Solution:** Clean, complete removal with data preservation options! **Handles Docker, Podman, or both.**

```bash
./universal-uninstaller.sh
```

**What It Does:**
- 🔍 **Auto-detects** what's installed (Docker, Podman, or both)
- 🛑 **Stops services** safely before removal
- 🗑️ **Removes packages** and binaries completely
- 📊 **Data options** - Keep or remove images/volumes/configs
- 🔒 **Multiple confirmations** - Won't delete without your permission
- 🧹 **System cleanup** - Removes leftover files and dependencies
- ✅ **Clean slate** - Like it was never installed

**Safety Features:**
- ⚠️ Multiple confirmation prompts
- 📝 Shows exactly what will be removed
- 💾 Option to keep container data
- 🔍 Verifies removal was successful
- 📚 Provides manual cleanup instructions if needed

---

### 🛡️ Built-In Safety (All Tools)

- ✅ Checks prerequisites before running
- ✅ Verifies system compatibility
- ✅ Shows what will happen before doing it
- ✅ Clear error messages with solutions
- ✅ Never runs destructive commands without asking

---

## 🚀 Quick Start

### 🎯 Easy Way (Recommended)

Use the **Universal Starter** - one script for everything!

```bash
# Clone the repository
git clone https://github.com/shadowdevnotreal/universal-docker.git
cd universal-docker

# Launch the universal menu
chmod +x universal-docker.sh
./universal-docker.sh
```

You'll see a menu with all tools:
- Install Docker/Podman
- Manage Containers
- Package Applications
- Uninstall Docker/Podman
- Help & About

### 🐧 Direct Access (Linux & macOS)

Or run individual scripts directly:

```bash
# Install Docker/Podman
./universal-installer.sh

# Manage containers
./docker-manager.sh

# Package your app
cd your-project
/path/to/docker-packager.sh

# Uninstall Docker/Podman
./universal-uninstaller.sh
```

### 🪟 Windows

**Easy Way (Recommended):**

Use the **Universal Starter** batch file!

```cmd
# Download or clone the repository
# Then double-click: universal-docker.bat
# Or run from Command Prompt:
universal-docker.bat
```

**Direct Install (PowerShell):**

```powershell
# Open PowerShell as Administrator, then run:
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/shadowdevnotreal/universal-docker/main/install-docker-windows.ps1" -OutFile "install-docker-windows.ps1"
.\install-docker-windows.ps1

# Follow the on-screen instructions
# After installation, Docker Desktop will be ready!
```

> 💡 **Windows Note:** Manager and Packager tools require WSL (Windows Subsystem for Linux). The batch file will guide you!

> 💡 **First time with containers?** Start with the Installer → try the Manager → then explore the Packager!

---

## 🤔 Docker vs Podman - Made Simple

**All tools in this toolkit work with BOTH Docker and Podman!**

You get to choose your container runtime on **all platforms**:

### 🐳 Docker Desktop
Think of it as the **industry standard**.
- Everyone uses it
- Tons of online help available
- Built-in Kubernetes support
- Full GUI on all platforms
- Uses more resources

**Availability:** Linux ✅ | macOS ✅ | Windows ✅

### 📦 Podman / Podman Desktop
Think of it as the **efficient alternative**.
- No background daemon (uses less resources!)
- More secure by default (rootless)
- 100% Docker-compatible commands
- Great for development
- Lightweight and fast

**Availability:** Linux ✅ | macOS ✅ (via Homebrew) | Windows ✅ (Podman Desktop)

**Can't decide?** Choose Docker - it's the safe bet! But Podman is perfect if you want something lighter.

---

## 📚 Need More Details?

**For Tech-Minded Users:** Check out our [Technical Wiki](WIKI.md) for:
- How the scripts work
- Security implementation details
- Architecture diagrams
- Advanced configuration options
- Troubleshooting guide

---

## 🎨 Features at a Glance

<div align="center">

| Feature | Description | Available In |
|---------|-------------|:------------:|
| 🚀 **Universal Starter** | One menu to access all tools | Starter |
| 🌐 **Cross-Platform** | Works on Linux, macOS, and Windows | Installer |
| 🎨 **Interactive Menus** | Colorful, easy-to-read interface | All Tools |
| 🔒 **Security Best Practices** | Non-root users, health checks, verified downloads | All Tools |
| 📊 **Status Display** | See what's running at a glance | Manager |
| 📦 **Auto-Detection** | Identifies your project type automatically | Packager |
| 🏗️ **Multi-Stage Builds** | 50-80% smaller Docker images | Packager |
| 🧹 **Cleanup Tools** | Free up disk space easily | Manager |
| 🗑️ **Complete Removal** | Clean uninstall with data options | Uninstaller |
| 📝 **View Logs** | See what your containers are doing | Manager |
| ⚡ **Fast Setup** | Get running in minutes | Installer |
| 💬 **Helpful Messages** | Clear instructions every step | All Tools |

</div>

---

## 🎥 What Happens During Installation?

<div align="center">

```
Step 1: 🔍 System Check
        ↓
Step 2: 🎯 Your Choice (Docker or Podman on Linux)
        ↓
Step 3: 📥 Download (latest official version)
        ↓
Step 4: ⚙️  Install (automated setup)
        ↓
Step 5: ✅ Verify (test that it works)
        ↓
Step 6: 🎉 Ready! (Container Manager tool available)
```

**Takes about 5-10 minutes** depending on your internet speed.

</div>

---

## 💡 Common Questions

<details>
<summary><b>Do I need to know how to code?</b></summary>

Nope! The Container Manager has a menu - just pick options with numbers. No typing commands needed.
</details>

<details>
<summary><b>Will this break my computer?</b></summary>

No! The script checks everything first and asks your permission before making changes.
</details>

<details>
<summary><b>I already have Docker. Can I still use this?</b></summary>

Yes! The script will detect it and ask if you want to continue. You can also just use the Container Manager tool.
</details>

<details>
<summary><b>What if something goes wrong?</b></summary>

The scripts show clear error messages and suggest solutions. You can also [open an issue](https://github.com/shadowdevnotreal/universal-docker/issues) and we'll help!
</details>

<details>
<summary><b>Is this safe?</b></summary>

Yes! We use official Docker installation methods and verify all downloads. See the [Wiki](WIKI.md) for security details.
</details>

---

## 🤝 Contributing

Love this project? Here's how you can help:

- ⭐ **Star this repository** - It helps others find it!
- 🐛 **Report bugs** - [Open an issue](https://github.com/shadowdevnotreal/universal-docker/issues)
- 💡 **Suggest features** - Tell us what you'd like to see
- 🔧 **Submit pull requests** - Help make it better
- 📢 **Spread the word** - Tell your friends!

[See Contribution Guidelines →](WIKI.md#contributing)

---

## 📖 Project Evolution

<div align="center">

| Phase | Tool | What It Does |
|:-----:|------|--------------|
| 🔧 **Phase 1-8** | Universal Installer | Cross-platform Docker/Podman installation |
| 🎨 **Phase 9** | Container Manager | Interactive menu-driven container management |
| 🐳 **Phase 10** | Podman Support | Lightweight, rootless container alternative |
| 📦 **Phase 11** | Docker Packager | Auto-generate production-ready Dockerfiles |
| 🗑️ **Phase 12** | Universal Uninstaller | **NEW!** Clean removal with data options |
| 🚀 **Phase 13** | Universal Starter | **NEW!** One menu for all tools |

**From installer to complete toolkit** - trusted by developers worldwide! 🌍

</div>

---

## 🆘 Support

### Need Help?

1. **Check the [Wiki](WIKI.md)** - Lots of answers there
2. **Search [existing issues](https://github.com/shadowdevnotreal/universal-docker/issues)** - Someone may have had the same problem
3. **Open a [new issue](https://github.com/shadowdevnotreal/universal-docker/issues/new)** - We're happy to help!

### Found a Bug?

Please include:
- Your operating system (Windows 10, Ubuntu 22.04, macOS Ventura, etc.)
- What you were trying to do
- The error message you saw
- The relevant section of output

---

## ☕ Support This Project

Creating and maintaining this project takes time and coffee ☕

If this tool saved you hours of frustration, consider:

<a href="https://www.buymeacoffee.com/diatasso" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-blue.png" alt="Buy Me A Coffee" style="height: 50px !important;" >
</a>

Every contribution helps keep this project alive and improving! 💙

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**TL;DR:** You can use, modify, and distribute this freely. Just keep the license notice.

---

## 🌟 Acknowledgments

- Docker team for their amazing containerization platform
- Podman team for the lightweight alternative
- All contributors who helped improve this project
- The open-source community for inspiration and support

---

<div align="center">

**Made with ❤️ for the community**

If this helped you, give it a ⭐ and share it with others!

[⬆ Back to Top](#universal-docker-installer)

</div>
