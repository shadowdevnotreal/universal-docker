#!/bin/bash
set -euo pipefail

# Version tracking
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)

# Check if the system is Ubuntu or Debian-based
if ! lsb_release -a 2>/dev/null | grep -iqE 'Ubuntu|Debian'; then
  echo "This script is designed for Ubuntu or Debian-based systems only."
  exit 1
fi

# Update the system
echo "Updating the system..."
sudo apt-get update && sudo apt-get upgrade -y

# Install Docker Engine & CLI
echo "Installing Docker Engine and CLI..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm -f get-docker.sh

# Install Docker Compose
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Installation complete. Docker and Docker Compose are now installed."
docker --version
docker-compose --version
