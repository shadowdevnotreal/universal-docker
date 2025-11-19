# GitHub Wiki Setup Instructions

This project has wiki content ready to publish to GitHub's Wiki tab.

## Quick Setup (2 Methods)

### Method 1: Manual Copy-Paste (Easiest)

1. Go to your repository on GitHub
2. Click the **"Wiki"** tab at the top
3. Click **"Create the first page"**
4. For each file in `wiki-pages/`, create a new wiki page:

**Pages to create:**
- Home (copy from `wiki-pages/Home.md`)
- Installation Details (copy from `wiki-pages/Installation-Details.md`)
- Docker Packager (copy from `wiki-pages/Docker-Packager.md`)
- Container Manager (copy from `wiki-pages/Container-Manager.md`)
- Architecture (copy from `wiki-pages/Architecture.md`)
- Security (copy from `wiki-pages/Security.md`)
- Troubleshooting (copy from `wiki-pages/Troubleshooting.md`)
- Examples (copy from `wiki-pages/Examples.md`)
- FAQ (copy from `wiki-pages/FAQ.md`)
- Contributing (copy from `wiki-pages/Contributing.md`)
- Changelog (copy from `wiki-pages/Changelog.md`)

### Method 2: Git Clone (Advanced)

1. Enable wiki in your GitHub repository settings
2. Clone the wiki repository:
   ```bash
   git clone https://github.com/shadowdevnotreal/universal-docker.wiki.git
   cd universal-docker.wiki
   ```

3. Copy all files from `wiki-pages/`:
   ```bash
   cp ../universal-docker/wiki-pages/*.md .
   ```

4. Commit and push:
   ```bash
   git add .
   git commit -m "Add comprehensive wiki documentation"
   git push origin master
   ```

## Wiki Structure

Once set up, your wiki will have this navigation:

```
Home
├── Installation Details
│   └── Platform-specific guides
├── Docker Packager
│   ├── Quick Start
│   ├── Supported Projects
│   └── Best Practices
├── Container Manager
│   └── Menu Options
├── Architecture
│   └── System Design
├── Security
│   └── Best Practices
├── Troubleshooting
│   └── Common Issues
├── Examples
│   └── Real-world Usage
├── FAQ
│   └── Common Questions
├── Contributing
│   └── How to Help
└── Changelog
    └── Version History
```

## Alternative: Use WIKI.md

If you prefer a single-file wiki, `WIKI.md` already contains all wiki content consolidated into one file. You can:
- Link to it from README: `[View Wiki](WIKI.md)`
- It's already in your repository at the root

## After Setup

Update your README links to point to the wiki:
```markdown
[Technical Wiki](../../wiki) instead of [Technical Wiki](WIKI.md)
```

## Files Created for Repository Tabs

The following files will appear in GitHub's repository interface:

| File | GitHub Tab/Location | Purpose |
|------|---------------------|---------|
| `.github/CONTRIBUTING.md` | "Insights" → "Community" | Contribution guidelines |
| `.github/SECURITY.md` | "Security" tab | Security policy and reporting |
| `.github/FUNDING.yml` | "Sponsor" button | Funding information |
| `OVERVIEW.md` | Can be linked from About | Project overview |
| `LICENSE` | Repository sidebar | License information |
| `WIKI.md` | Code tab | Consolidated wiki |
| `wiki-pages/*.md` | Ready for Wiki tab | Individual wiki pages |

## Enhancing Repository Discoverability

### Add Repository Topics
Go to your repository → Click the gear icon next to "About" → Add topics:
- `docker`
- `podman`
- `containers`
- `containerization`
- `dockerfile`
- `docker-compose`
- `devops`
- `automation`
- `bash`
- `shell-script`
- `beginner-friendly`
- `cross-platform`

### Set Repository Description
In "About" section, set description:
> One-click Docker/Podman installer and container manager for Linux, macOS, and Windows. Interactive Dockerfile generator with best practices built-in.

### Enable Features
Enable in Settings:
- [x] Wiki
- [x] Issues
- [x] Discussions (optional - for community Q&A)
- [x] Sponsorships (if you want to accept donations)

## Result

After setup, users visiting your repository will see:
- **Code tab**: Main files including README, scripts
- **Wiki tab**: Comprehensive documentation (11 pages)
- **Security tab**: Security policy
- **Insights → Community**: Community health files
- **Sponsor button**: Buy Me A Coffee link
- **About section**: Description, topics, license badge

This makes your project look professional and easy to navigate!
