#!/bin/bash

# Update package lists
echo "Updating package lists..."
apt-get update -y

# Install prerequisites for Node.js
echo "Installing curl and other prerequisites..."
apt-get install -y curl
if [ $? -eq 0 ]; then
    echo "Curl installed successfully."
else
    echo "Failed to install curl."
    exit 1
fi

# Add NodeSource repository for Node.js (LTS version, e.g., 20.x at the time of writing)
echo "Setting up NodeSource repository..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
if [ $? -eq 0 ]; then
    echo "NodeSource repository added."
else
    echo "Failed to add NodeSource repository."
    exit 1
fi

# Install Node.js and npm
echo "Installing Node.js and npm..."
apt-get install -y nodejs
if [ $? -eq 0 ]; then
    echo "Node.js and npm installed successfully."
    node -v
    npm -v
else
    echo "Failed to install Node.js."
    exit 1
fi

# Install Vim
echo "Installing Vim..."
apt-get install -y vim
if [ $? -eq 0 ]; then
    echo "Vim installed successfully."
else
    echo "Failed to install Vim."
    exit 1
fi

# Install Git
echo "Installing Git..."
apt-get install -y git
if [ $? -eq 0 ]; then
    echo "Git installed successfully."
else
    echo "Failed to install Git."
    exit 1
fi

echo "Bootstrap script completed."