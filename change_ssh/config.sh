#!/bin/bash 

# ===============================
# 2. Change Hostname (Alias) in SSH Config
# If you want to rename or configure a host alias in your SSH client 
# (so you can ssh #myserver instead of typing full details),                 
# edit ~/.ssh/config.
# ===============================

HOST_ALIAS="myserver"
HOSTNAME="192.168.1.100"
USER="abolfazl"
PORT="22"

CONFIG_FILE="$HOME/.sss/config"

# Create config file if does not exist
[ ! -f "$CONFIG_FILE"] && touch "$CONFIG_FILE"


# Remove old config for alias if exists
sed -i "/^Host $HOST_ALIAS$/,/^$/d" "$CONFIG_FILE"