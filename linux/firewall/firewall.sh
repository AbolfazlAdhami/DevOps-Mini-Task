#!/bin/bash

# simple firewall iptables setup

sudo apt update -y 
sudo apt install iptables
#check for insatalltion
iptables --version
iptables -V


# Flush existing rules
iptables -F
iptables -X

# Drop all Rules
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Allow loopback interface (local traffic)
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT


# Accepts incoming traffic on port 80 (HTTP) and port 443 (HTTPS).
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT


# Rejects all other traffic.
iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "IPTables-Dropped: " --log-level 4
# Log Droped trafic.
sudo iptables -A INPUT -j LOG --log-prefix "IPTables-Dropped: "

# Reject everything else
iptables -A INPUT -j REJECT




#Includes a rule to log rejected packets to a file.
iptables -L -v
sudo sh -c 'iptables-save > /etc/iptables/rules.v4'