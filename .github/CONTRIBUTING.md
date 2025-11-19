# Contributing to Universal Docker

Thank you for considering contributing to Universal Docker! We welcome contributions from everyone.

## Ways to Contribute

### Star and Share
- Star this repository to help others find it
- Share it with friends and colleagues
- Tweet about it or mention it in blog posts

### Report Bugs
Found a bug? Please [open an issue](https://github.com/shadowdevnotreal/universal-docker/issues/new) with:
- Your operating system (Windows 10, Ubuntu 22.04, macOS Ventura, etc.)
- What you were trying to do
- The error message you saw
- The relevant section of output

### Suggest Features
Have an idea? [Open an issue](https://github.com/shadowdevnotreal/universal-docker/issues/new) and describe:
- What feature you'd like to see
- Why it would be useful
- Any examples or mockups

### Submit Code
Want to contribute code? Great! Here's how:

1. **Fork the repository**
2. **Create a branch**: `git checkout -b feature/my-awesome-feature`
3. **Make your changes**
4. **Test thoroughly**:
   - Test on your OS
   - Ensure existing functionality still works
   - Add comments to complex code
5. **Commit**: Use clear, descriptive commit messages
6. **Push**: `git push origin feature/my-awesome-feature`
7. **Create a Pull Request**

## Code Style

- Use 4-space indentation for shell scripts
- Add comments for complex logic
- Follow existing code patterns
- Use `set -euo pipefail` for error handling
- Test on multiple platforms when possible

## Development Workflow

### For Shell Scripts
```bash
# Test syntax
bash -n script-name.sh

# Test functionality
./script-name.sh
```

### For PowerShell Scripts
```powershell
# Test syntax
Get-Command .\script-name.ps1

# Test functionality
.\script-name.ps1
```

## Pull Request Guidelines

### Good PR Title Examples
- `Add support for Arch Linux`
- `Fix Docker installation on macOS Monterey`
- `Improve error messages in Container Manager`

### PR Description Should Include
- What changes you made
- Why you made them
- How to test them
- Screenshots (if UI changes)

## Testing Checklist

Before submitting, ensure:
- [ ] Code follows project style
- [ ] No syntax errors (`bash -n` passes)
- [ ] Tested on relevant OS
- [ ] Error messages are clear and helpful
- [ ] Documentation updated (if needed)
- [ ] No hardcoded paths or credentials

## Community Guidelines

- Be respectful and constructive
- Help others learn
- Give credit where it's due
- Focus on making the project better

## Need Help?

Not sure how to contribute? That's okay!
- Ask questions in [Discussions](https://github.com/shadowdevnotreal/universal-docker/discussions)
- Comment on existing issues
- Review others' pull requests

## Recognition

All contributors will be recognized in our README and release notes!

Thank you for making Universal Docker better!
