# Universal Docker Installer - TODO List

**Philosophy**: Code with purpose. Keep it lean, secure, and clear. Put responsibility on the user when it makes sense.

---

## Phase 1: Make It Actually Work ✓
*Fix broken code so scripts execute*

- [x] Remove markdown code blocks from `universal-installer.sh` (lines 3-4, 47)
- [x] Remove markdown code blocks from `install-docker-mac.sh` (lines 1-2, 20)
- [x] Add shebang validation (ensure scripts start properly)
- [x] Test that all scripts can execute without syntax errors

---

## Phase 2: Fix Critical Bugs ✓
*Address issues that cause failures*

- [x] Add `sudo` for macOS `/Applications` copy (line 13)
- [x] Clean up downloaded `get-docker.sh` after Linux installation
- [x] Add basic error handling with `set -euo pipefail` to all scripts
- [x] Fix install-docker-mac.sh to handle Intel vs Apple Silicon (or just tell user which to download)

---

## Phase 3: Don't Break What Already Exists ✓
*Prevent destructive behavior*

- [x] Check if Docker is already installed before proceeding
- [x] Warn user if Docker exists and ask if they want to continue
- [x] Add prerequisite checks (OS version, permissions)
- [x] For Windows: Just tell user system requirements, let them verify

---

## Phase 4: Better User Communication ✓
*Clear messages > automation when it makes sense*

- [x] Add clear status messages during installation steps
- [x] Display what's about to happen before doing it
- [x] Show helpful error messages when things fail
- [x] For Windows: Consider just showing download link + instructions vs auto-installing

---

## Phase 5: Fix Documentation ✓
*Make README match reality*

- [x] Fix incorrect directory name (line 39: `universal-docker-installer` → `universal-docker`)
- [x] Remove placeholder `<your-username>` (line 63)
- [x] Remove "ChatConvert Toolkit" copy-paste error (line 87)
- [x] Fix repository URL placeholder (line 96)
- [x] Clean up duplicate donation sections
- [x] Add note about checking prerequisites manually

---

## Phase 6: Security Essentials ✓
*Only what's practical and doesn't overcomplicate*

- [x] Add SHA256 verification for Docker Compose (it's available on GitHub)
- [x] Skip GPG verification (too complex, Docker's official script handles it)
- [x] Document security considerations for users
- [x] Add note that users should verify downloads themselves if paranoid

---

## Phase 7: Handle Edge Cases ✓
*Things that will actually happen*

- [x] Handle GitHub API rate limiting (fallback to recent version number)
- [x] Add network failure messages (don't just fail silently)
- [x] Check for `curl` availability (already implemented)
- [x] Graceful handling when DMG mount fails on macOS

---

## Phase 8: Polish & Quality ✓
*Make it maintainable*

- [x] Run `shellcheck` on all scripts and fix critical issues (manual syntax validation)
- [x] Add comments explaining non-obvious commands
- [x] Consistent formatting across all scripts
- [x] Add version numbers to scripts

---

## Phase 9: Interactive Docker Management
*Easy menu for Docker operations*

- [ ] Create interactive shell script menu for Docker management
  - Start/stop Docker daemon
  - Check Docker status
  - View running containers
  - List images
  - Clean up unused resources (prune)
  - View logs
  - Restart Docker service
- [ ] Make menu cross-platform (Linux/macOS compatible)
- [ ] Add option to launch management menu from installer

---

## Phase 10: Lightweight Alternatives
*Avoid memory hogs when possible*

- [ ] Linux: Add Podman as alternative installation option
  - Podman is daemonless (lighter than Docker)
  - Docker-compatible CLI
  - Runs containers without root
- [ ] macOS: Consider adding Colima as alternative to Docker Desktop
  - Colima uses Lima VM (lightweight)
  - Much less resource usage than Docker Desktop
  - Docker-compatible
- [ ] Create option menu: "Docker Engine" vs "Podman" (Linux only)
- [ ] Document resource differences between options

---

## Won't Do (User Responsibility)
*Things users should handle themselves*

- ❌ Rollback functionality (too complex, users can uninstall manually)
- ❌ Uninstall scripts (Docker has official uninstall docs)
- ❌ WSL2 setup for Windows (let user read Docker's official guide)
- ❌ macOS version detection (just tell user minimum version)
- ❌ Full test suite (manual testing is fine for this scope)
- ❌ CI/CD pipeline (overkill for simple installer scripts)
- ❌ Version selection UI (users can modify script if they want specific version)

---

## Notes

**Keeping it lean means:**
- Scripts should install Docker, not become Docker themselves
- When in doubt, show a message > write complex code
- Official documentation exists for a reason - reference it
- Users who need advanced features can fork and modify

**Current Status:** Starting Phase 1

---

## Progress Tracking

Mark items with `[x]` as completed. Date completed phases below:

- Phase 1: ✓ Completed
- Phase 2: ✓ Completed
- Phase 3: ✓ Completed
- Phase 4: ✓ Completed
- Phase 5: ✓ Completed
- Phase 6: ✓ Completed
- Phase 7: ✓ Completed
- Phase 8: ✓ Completed
- Phase 9: Not started (Interactive Docker Management)
- Phase 10: Not started (Lightweight Alternatives)
