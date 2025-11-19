# Universal Docker Installer - Technical Wiki

<div align="center">

**Technical Documentation for Developers and System Administrators**

</div>

---

## Welcome

This wiki provides comprehensive technical documentation for the Universal Docker Installer project. Whether you're a developer looking to contribute, a system administrator deploying the solution, or a user seeking deeper understanding, you'll find detailed information here.

## Quick Navigation

### 📚 Core Documentation
- **[Installation Details](Installation-Details)** - Platform-specific installation processes
- **[Architecture](Architecture)** - System design and component interactions
- **[Security](Security)** - Security implementation and threat model

### 🛠️ Tools & Components
- **[Container Manager](Container-Manager)** - Interactive management tool details
- **[Docker Packager](Docker-Packager)** - Application packaging tool (NEW!)
- **[Script Specifications](Script-Specifications)** - Error handling, logging, and conventions

### 🔧 Maintenance & Development
- **[Troubleshooting](Troubleshooting)** - Common issues and solutions
- **[Advanced Configuration](Advanced-Configuration)** - Customization options
- **[Contributing](Contributing)** - Development setup and guidelines
- **[API Reference](API-Reference)** - Function and variable documentation

---

## Project Overview

### Project Structure

```
universal-docker/
├── universal-installer.sh      # Main entry point (Linux/macOS)
├── install-docker-linux.sh     # Linux-specific installer
├── install-docker-mac.sh       # macOS-specific installer
├── install-docker-windows.ps1  # Windows-specific installer
├── docker-manager.sh           # Interactive container management tool (v2.0)
├── docker-packager.sh          # Application packager tool (v1.0) NEW!
├── README.md                   # User-friendly documentation
├── TODO.md                     # Development roadmap
├── wiki-pages/                 # Technical wiki (you're reading this!)
└── LICENSE                     # MIT License
```

### Version Information

| Component | Version | Language | Lines of Code |
|-----------|---------|----------|---------------|
| universal-installer.sh | 1.0.0 | Bash | ~50 |
| install-docker-linux.sh | 1.0.0 | Bash | ~230 |
| install-docker-mac.sh | 1.0.0 | Bash | ~150 |
| install-docker-windows.ps1 | 1.0.0 | PowerShell | ~110 |
| docker-manager.sh | 2.0.0 | Bash | ~610 |

---

## Performance Considerations

### Installation Time

| Platform | Docker | Podman | Factors |
|----------|--------|--------|---------|
| Linux | 5-10 min | 3-5 min | Internet speed, CPU |
| macOS | 10-15 min | N/A | Download size (~500MB) |
| Windows | 10-20 min | N/A | WSL 2 initialization |

### Resource Usage

**Docker (with daemon):**
- Memory: ~2GB base + containers
- CPU: ~1-2% idle
- Disk: ~4GB for Docker Desktop

**Podman (daemonless):**
- Memory: 0MB idle (only when containers run)
- CPU: 0% idle
- Disk: ~500MB for Podman

---

## License

MIT License - see [LICENSE](https://github.com/shadowdevnotreal/universal-docker/blob/main/LICENSE) for full text.

**Summary:**
- ✅ Commercial use
- ✅ Modification
- ✅ Distribution
- ✅ Private use
- ℹ️ License and copyright notice required
- ❌ No liability
- ❌ No warranty

---

## References

**Official Documentation:**
- [Docker Docs](https://docs.docker.com/)
- [Podman Docs](https://docs.podman.io/)
- [Docker Compose Docs](https://docs.docker.com/compose/)

**Repositories:**
- [Docker Engine](https://github.com/docker/docker-ce)
- [Docker Compose](https://github.com/docker/compose)
- [Podman](https://github.com/containers/podman)

**Security:**
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
- [Podman Security](https://docs.podman.io/en/latest/markdown/podman-security.1.html)

---

<div align="center">

**Questions? [Open an Issue](https://github.com/shadowdevnotreal/universal-docker/issues)**

</div>
