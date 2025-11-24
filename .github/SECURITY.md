# Security Policy

## Supported Versions

We actively support the latest version of Universal Docker. Security updates are applied to the main branch.

| Version | Supported          |
| ------- | ------------------ |
| Latest (main branch) | :white_check_mark: |
| Older commits | :x: |

## Security Features

Universal Docker includes several security features:

### Installation Scripts
- Official Docker/Podman sources only
- GPG key verification for package downloads
- SHA256 checksum validation
- No arbitrary code execution from external sources
- User permission prompts before system changes

### Docker Packager
- Non-root users by default (UID 1001)
- .dockerignore to prevent secret leakage
- Multi-stage builds to minimize attack surface
- Health checks for container monitoring
- No secrets in generated Dockerfiles

### Container Manager
- Read-only operations by default
- Clear user prompts before destructive actions
- No automatic data deletion without confirmation

## Reporting a Vulnerability

**Please DO NOT open a public issue for security vulnerabilities.**

Instead, please report security issues privately:

1. **Email**: Create an issue with title "SECURITY - [brief description]" and mark it as private
2. **Include**:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### What to Expect

- **Response Time**: We aim to respond within 48 hours
- **Investigation**: We'll investigate and validate the report
- **Fix Timeline**: Critical issues will be patched within 7 days
- **Disclosure**: We'll coordinate disclosure timing with you
- **Credit**: You'll be credited in the security advisory (if desired)

## Security Best Practices for Users

### When Installing
- Download only from official GitHub repository
- Verify you're on `https://github.com/shadowdevnotreal/universal-docker`
- Check the code before running (transparency is key!)
- Run with appropriate permissions (don't run as root unless needed)

### When Using Docker Packager
- Review generated Dockerfiles before building
- Don't commit `.env` files (they're in .dockerignore by default)
- Use secrets management for production (not environment variables)
- Regularly update base images
- Scan images for vulnerabilities (use `docker scan` or Trivy)

### When Managing Containers
- Only run containers from trusted images
- Limit container privileges
- Use network isolation
- Regularly update Docker/Podman
- Monitor container logs

## Known Limitations

### Not Suitable For
- Production environments without review
- Automated CI/CD without validation
- Untrusted multi-user systems
- Environments requiring audit trails

### User Responsibility
This tool generates configurations and runs system commands. Users are responsible for:
- Reviewing generated files before use
- Understanding what the scripts do
- Securing their containers and images
- Keeping Docker/Podman updated
- Following their organization's security policies

## Security Updates

Security patches are released as soon as possible. To stay updated:
- Watch this repository for releases
- Check the [CHANGELOG](WIKI.md) regularly
- Subscribe to GitHub notifications

## Acknowledgments

We appreciate responsible disclosure from the security community. Contributors who report valid vulnerabilities will be thanked in our security advisories (unless they prefer to remain anonymous).

---

**Last Updated**: 2025-11-19
