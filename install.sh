#!/bin/bash
# **************************************************************************** #
#                                                                              #
# Script to install Docker, Docker Compose, and dependencies on Ubuntu/Debian  #
#                                                                              #
# **************************************************************************** #

set -e

echo "[+] Installing dependencies..."
sudo apt install -y \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common

echo "[+] Adding Docker's official GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "[+] Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[+] Installing Docker Engine and Docker Compose..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[+] Adding current user to docker group..."
sudo usermod -aG docker $USER

echo "[+] Enabling Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo "[+] Installation complete!"
echo "Please log out and log back in so you can run Docker without sudo."
echo "Verify with: docker --version && docker compose version"
