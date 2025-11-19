<div align="center">

<img width="512" alt="Universal Docker Logo" src="https://github.com/user-attachments/assets/363b9a14-6154-4dcf-9311-9e27c62427ef" />

# 🐳 Universal Docker

### One-click Docker/Podman installer, manager, and packager for everyone

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

🎯 **Install Docker/Podman in one command** - No confusing steps, no tech knowledge needed
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

## ✨ Three Powerful Tools

<div align="center">

| 🤖 Universal Installer | 🎨 Container Manager | 📦 Docker Packager |
|:---:|:---:|:---:|
| **One-command setup** | **Visual interface** | **Auto-generate Dockerfiles** |
| Install Docker/Podman | Manage containers with menus | Turn apps into containers |
| Linux, macOS, Windows | No CLI commands needed | Zero Docker knowledge required |
| `./universal-installer.sh` | `./docker-manager.sh` | `./docker-packager.sh` |

</div>

---

### 🤖 Tool 1: Universal Installer

**The Problem:** Installing Docker is confusing - different steps for each OS, complicated commands, unclear errors.

**The Solution:** One script that handles everything for you.

```bash
# Linux & Mac
./universal-installer.sh

# Windows (PowerShell Admin)
.\install-docker-windows.ps1
```

**What It Does:**
- ✅ Detects your operating system automatically
- ✅ Installs Docker OR Podman (you choose on Linux!)
- ✅ Verifies installation works correctly
- ✅ Sets up everything needed to run containers
- ✅ Shows clear progress messages

**Platforms:** Linux, macOS, Windows

---

### 🎨 Tool 2: Container Manager

**The Problem:** Docker CLI commands are hard to remember - `docker ps -a`, `docker system prune -a`, etc.

**The Solution:** A beautiful interactive menu - just pick numbers!

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
- ✅ Check Docker/Podman status
- ✅ Start/stop container runtime
- ✅ List and manage containers
- ✅ View container logs
- ✅ Free up disk space
- ✅ No commands to memorize!

**Supports:** Docker and Podman

---

### 📦 Tool 3: Docker Packager **NEW!**

**The Problem:** Creating Dockerfiles requires Docker expertise - base images, multi-stage builds, security hardening...

**The Solution:** Auto-generate production-ready Dockerfiles with best practices built-in!

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
- 🐳 **Works with Docker AND Podman** seamlessly
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

### 🛡️ Built-In Safety (All Tools)

- ✅ Checks prerequisites before running
- ✅ Verifies system compatibility
- ✅ Shows what will happen before doing it
- ✅ Clear error messages with solutions
- ✅ Never runs destructive commands without asking

---

## 🚀 Quick Start

### 🐧 Linux & macOS

```bash
# Clone the repository
git clone https://github.com/shadowdevnotreal/universal-docker.git
cd universal-docker

# Make installer executable and run it
chmod +x universal-installer.sh
./universal-installer.sh

# After installation, try the Container Manager
./docker-manager.sh

# Or package your app with Docker Packager
cd your-project
/path/to/docker-packager.sh
```

### 🪟 Windows

```powershell
# Open PowerShell as Administrator, then run:
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/shadowdevnotreal/universal-docker/main/install-docker-windows.ps1" -OutFile "install-docker-windows.ps1"
.\install-docker-windows.ps1

# Follow the on-screen instructions
# After installation, Docker Desktop will be ready!
```

> 💡 **First time with containers?** Start with the Installer → try the Manager → then explore the Packager!

---

## 🤔 Docker vs Podman - Made Simple

On Linux, you get to choose between two options:

### 🐳 Docker
Think of it as the **popular kid** at school.
- Everyone uses it
- Tons of online help available
- Works with everything
- Uses more computer memory

### 📦 Podman
Think of it as the **efficient kid** at school.
- Uses less memory (no background processes!)
- More secure by design
- Works almost exactly like Docker
- Great for learning and development

**Can't decide?** Choose Docker - it's the safe bet!

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
| 🌐 **Cross-Platform** | Works on Linux, macOS, and Windows | Installer |
| 🎨 **Interactive Menus** | Colorful, easy-to-read interface | All Tools |
| 🔒 **Security Best Practices** | Non-root users, health checks, verified downloads | All Tools |
| 📊 **Status Display** | See what's running at a glance | Manager |
| 📦 **Auto-Detection** | Identifies your project type automatically | Packager |
| 🏗️ **Multi-Stage Builds** | 50-80% smaller Docker images | Packager |
| 🧹 **Cleanup Tools** | Free up disk space easily | Manager |
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
| 📦 **Phase 11** | Docker Packager | **NEW!** Auto-generate production-ready Dockerfiles |

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
