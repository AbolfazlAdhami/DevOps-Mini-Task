#!/bin/bash

# Update Packages
echo "Updating package lists..."
apt-get update -y

# Install Python 3 and pip
echo "Installing Python 3 and pip..."
apt-get install -y python3 python3-pip
if [ $? -eq 0 ]; then
    echo "Python 3 and pip installed successfully."
else
    echo "Failed to install Python 3 and pip."
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

# Install Nginx
echo "Installing Nginx..."
apt-get install -y nginx
if [ $? -eq 0 ]; then
    echo "Nginx installed successfully."
    # Ensure Nginx is enabled and started
    systemctl enable nginx
    systemctl start nginx
    if [ $? -eq 0 ]; then
        echo "Nginx started and enabled."
    else
        echo "Failed to start Nginx."
        exit 1
    fi
else
    echo "Failed to install Nginx."
    exit 1
fi

echo "Bootstrap script completed."