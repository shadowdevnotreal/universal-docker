### Bash Script for macOS

```bash
#!/bin/bash

echo "Downloading Docker Desktop for Mac..."
curl -L "https://desktop.docker.com/mac/stable/Docker.dmg" -o ~/Downloads/Docker.dmg

echo "Mounting Docker.dmg..."
hdiutil attach ~/Downloads/Docker.dmg

echo "Installing Docker Desktop..."
cp -R /Volumes/Docker/Docker.app /Applications

echo "Cleanup..."
hdiutil detach /Volumes/Docker
rm ~/Downloads/Docker.dmg

echo "Docker Desktop installed successfully."
