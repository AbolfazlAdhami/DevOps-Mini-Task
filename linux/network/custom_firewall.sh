#!/bin/bash
# custom_firewall.sh

# پاک کردن قوانین قبلی
iptables -F
iptables -X

# پیش‌فرض: رد همه
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# اجازه به loopback
iptables -A INPUT -i lo -j ACCEPT

# اجازه به کانکشن‌های موجود
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# اجازه به HTTP و HTTPS
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# لاگ گرفتن از بسته‌های رد شده
iptables -A INPUT -j LOG --log-prefix "IPTables-Dropped: " --log-level 4
