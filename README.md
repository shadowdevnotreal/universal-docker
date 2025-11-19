# Universal Docker Installer

<div align="center">

![Docker Logo](https://github.com/shadowdevnotreal/universal-docker/assets/43219706/da74af2f-5612-45c9-aa71-e67d15f93be9)

[![GitHub stars](https://img.shields.io/github/stars/shadowdevnotreal/universal-docker?style=social)](https://github.com/shadowdevnotreal/universal-docker/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/shadowdevnotreal/universal-docker?style=social)](https://github.com/shadowdevnotreal/universal-docker/network/members)
[![GitHub watchers](https://img.shields.io/github/watchers/shadowdevnotreal/universal-docker?style=social)](https://github.com/shadowdevnotreal/universal-docker/watchers)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20Windows-blue)](https://github.com/shadowdevnotreal/universal-docker)
[![Shell Script](https://img.shields.io/badge/Shell_Script-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://docs.microsoft.com/en-us/powershell/)

**One-click container setup for everyone** 🚀

[Get Started](#-quick-start) • [Features](#-what-you-get) • [Wiki](WIKI.md) • [Support](#-support)

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

## ✨ What You Get

### 🤖 Automatic Installation
- **Linux**: Choose Docker or Podman (your pick!)
- **macOS**: Docker Desktop installed automatically
- **Windows**: Docker Desktop with simple setup

### 📦 Container Manager Tool
**NEW!** A beautiful menu that anyone can use:

```
========================================
   Container Manager - Easy Mode 🐳
========================================

● Docker is running
Running containers: 2

What would you like to do?

  1. Check status
  2. Start Docker
  3. Stop Docker
  ... and more!
```

**No commands to memorize!** Just pick a number and go.

### 📦 Docker Packager Tool
**NEW!** Turn your apps into Docker containers with zero Docker knowledge:

```
========================================
   Docker/Podman Application Packager
========================================

✓ Detected: Node.js (found package.json)

What would you like to do?

  1. Create Dockerfile (Interactive)
  2. Build & Test Container
  3. Generate Docker Compose
  4. Show Project Info
  5. Exit
```

**Features:**
- 🎯 **Auto-detects** your project type (Node.js, Python, Go, Static)
- 📝 **Creates Dockerfiles** with best practices built-in
- 🏗️ **Builds & tests** your container automatically
- 🐳 **Works with Docker AND Podman** seamlessly
- 🔒 **Secure by default** (non-root users, health checks)
- 💨 **Multi-stage builds** for tiny images

**Just run:** `./docker-packager.sh` in your project folder!

### 🛡️ Built-In Safety
- ✅ Checks if Docker is already installed
- ✅ Verifies your system is compatible
- ✅ Shows you what will happen before doing it
- ✅ Clean error messages if something goes wrong

---

## 🚀 Quick Start

### Linux & Mac Users

**Step 1:** Open your terminal (it's usually in Applications/Utilities on Mac)

**Step 2:** Copy and paste this:
```bash
git clone https://github.com/shadowdevnotreal/universal-docker.git
cd universal-docker
chmod +x universal-installer.sh
./universal-installer.sh
```

**Step 3:** Follow the prompts - the script will guide you!

### Windows Users

**Step 1:** Right-click the Windows button and select "PowerShell (Admin)"

**Step 2:** Copy and paste this:
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/shadowdevnotreal/universal-docker/main/install-docker-windows.ps1" -OutFile "install-docker-windows.ps1"
.\install-docker-windows.ps1
```

**Step 3:** Follow the on-screen instructions!

> 💡 **Tip:** After installation, use the Container Manager tool - just run `./docker-manager.sh`

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

| Feature | Description |
|---------|-------------|
| 🌐 **Cross-Platform** | Works on Linux, macOS, and Windows |
| 🎨 **Interactive Menus** | Colorful, easy-to-read interface |
| 🔒 **Security Checks** | Verifies downloads automatically |
| 📊 **Status Display** | See what's running at a glance |
| 🧹 **Cleanup Tools** | Free up disk space easily |
| 📝 **View Logs** | See what your containers are doing |
| ⚡ **Fast Setup** | Get running in minutes |
| 💬 **Helpful Messages** | Clear instructions every step |

---

## 🎥 What Happens During Installation?

1. **System Check** - We verify your computer meets requirements
2. **Your Choice** - Pick Docker or Podman (Linux only)
3. **Download** - We get the latest official version
4. **Install** - Everything is set up automatically
5. **Verify** - We test that it works
6. **Ready!** - You get the Container Manager tool

**Takes about 5-10 minutes** depending on your internet speed.

---

## 📦 Using the Docker Packager

Once Docker or Podman is installed, you can easily package your applications into containers!

### Quick Example: Dockerize a Node.js App

```bash
# Navigate to your project
cd my-awesome-app

# Run the packager
./docker-packager.sh

# Select option 1: Create Dockerfile
# Answer a few questions (port, entry command)
# Done! Dockerfile and .dockerignore created

# Select option 2: Build & Test
# Your app is now in a container!
```

### Supported Project Types

| Type | Detection | What It Creates |
|------|-----------|-----------------|
| **Node.js** | package.json | Multi-stage Dockerfile with npm ci |
| **Python** | requirements.txt, pyproject.toml | Multi-stage with pip |
| **Go** | go.mod | Multi-stage with CGO_ENABLED=0 |
| **Static** | index.html | nginx-based static server |

### What Gets Generated

#### Dockerfile Features
✅ Multi-stage builds (50-80% smaller images)
✅ Non-root user (UID 1001)
✅ Health checks
✅ Layer optimization for fast rebuilds
✅ Security best practices

#### .dockerignore
Automatically excludes:
- `node_modules/`, `venv/`, etc.
- `.git/`, `.env` files
- Build artifacts
- Logs and temporary files

#### docker-compose.yml (Optional)
Choose from:
- PostgreSQL database
- Redis cache
- MongoDB
- Complete networking setup
- Volume configuration

### Prerequisites Check

The packager automatically checks for:
- Docker or Podman (required)
- docker-compose / podman-compose (for compose generation)
- Standard Unix tools (sed, grep, awk)

If anything is missing, you'll get clear installation instructions!

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

## 📖 Project History

This project started as a simple Docker installer but grew into something much bigger:

- **Phase 1-8**: Core installation scripts with safety features
- **Phase 9**: Container Manager - the game-changing interactive tool
- **Phase 10**: Podman support - lightweight Docker alternative
- **Phase 11**: Docker Packager - turn your apps into containers with zero Docker knowledge

**Today**: A complete container setup and packaging solution trusted by developers worldwide!

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
