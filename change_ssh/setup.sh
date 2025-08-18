#!/bin/bash

# ========================
# 1. Change Hostname on the Server
# ========================

# New hostname you want to set
NEW_HOSTNAME="new-hostname"

# Set hostname temporarily (unit reboot)
sudo hostnamectl set-hostname "$NEW_HOSTNAME"


# Update /etc/hosts to reflect the new hostname
sudo set -i "s/127.0.1.1.*/127.0.1.1 $NEW_HOSTNAME/" /etc/hosts


echo "Hostname changed to $NEW_HOSTNAME. Please reboot for changes to take effect."
