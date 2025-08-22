#!/bin/bash 

# === Variables ===
USERNAME="abolfazl"
PACKAGE_KEYWORD="bottleneck"


# === 1. Create user with home dir and bash shell ===
sudo useradd -m -s /bin/bash "$USERNAME"

# === 2. Set password ===
echo "[+] Setting password for $USERNAME"
sudo passwd "$USERNAME"

# === 3. Add user to sudo group ===
echo "[+] Adding $USERNAME to sudo group"
sudo usermod -aG sudo "$USERNAME"


# === 4. Search for service ===
echo "[+] Searching for packages: $PACKAGE_KEYWORD"
sudo apt update
apt search "$PACKAGE_KEYWORD" | grep -i "$PACKAGE_KEYWORD"


# === 3. Add user to sudo group ===
read -p "[?] Enter the exact package name to install: " PKG_NAME
if [ -n "$PKG_NAME"]; then
    echo "[+] Installing $PKG_NAME..."
    sudo apt install -y "$PKG_NAME"
else 
    echo "[!] No package name entered. Skipping installation."
fi 

echo "[+] Done."
