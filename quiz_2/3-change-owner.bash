#!/bin/bash 

# ===Variables ===
TARGET_DIR="/var/www/project"
NEW_OWNER="ABOLFAZL"
NEW_GROUP="Developer"

# === 1.Show Current ownership ===
echo "[+] Current ownership:"
ls -l "$TARGET_DIR"

# === 2. change ownership recursively ===
echo "[+] Changing owner to $NEW_OWNER:$NEW_GROUP recursively..."
sudo chown -R "$NEW_OWNER":"$NEW_GROUP" "$TARGET_DIR"

# === 3.Show ownership after change
echo "[+] Ownership after change"
ls -l "$TARGET_DIR"

echo "[+] Done!"