#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "🔹 Updating system..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "🔹 Installing required packages..."
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "🔹 Adding Docker’s official GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "🔹 Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🔹 Installing Docker Engine and CLI..."
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "🔹 Adding your user to docker group..."
sudo usermod -aG docker $USER

echo "✅ Docker installation finished!"
echo "🔹 Checking Docker version..."
docker --version
docker compose version

echo "⚠️ Please log out and log back in (or run 'newgrp docker') to use Docker without sudo."
