#!/bin/bash
# setup_iptables.sh
# Firewall configuration for devapp01

# Switch to root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo bash setup_iptables.sh)"
  exit
fi

echo "Configuring iptables rules on devapp01..."

# Flush existing rules
iptables -F
iptables -X

# Default policy (ACCEPT for now)
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow established/related connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow SSH (port 22) from Bob's laptop
iptables -A INPUT -p tcp -s 172.16.238.187 --dport 22 -j ACCEPT

# Allow HTTP (port 80) from Bob's laptop
iptables -A INPUT -p tcp -s 172.16.238.187 --dport 80 -j ACCEPT

# Drop all other incoming connections
iptables -A INPUT -j DROP

# Allow outgoing PostgreSQL (port 5432) to devdb01
iptables -A OUTPUT -p tcp -d 172.16.238.11 --dport 5432 -j ACCEPT

# Allow outgoing HTTP (port 80) to caleston-repo-01
iptables -A OUTPUT -p tcp -d 172.16.238.15 --dport 80 -j ACCEPT

# Allow outgoing HTTPS (port 443) to google.com
GOOGLE_IP=$(dig +short google.com | head -n 1)
if [ -n "$GOOGLE_IP" ]; then
  iptables -I OUTPUT 1 -p tcp -d $GOOGLE_IP --dport 443 -j ACCEPT
  echo "Added HTTPS allow rule for google.com ($GOOGLE_IP)"
else
  echo "Warning: Could not resolve google.com; skipping HTTPS rule."
fi

# Drop all other HTTP (80) and HTTPS (443) traffic
iptables -A OUTPUT -p tcp --dport 80 -j DROP
iptables -A OUTPUT -p tcp --dport 443 -j DROP

# Save rules
iptables-save > /etc/iptables/rules.v4

echo "Firewall configuration applied successfully!"
