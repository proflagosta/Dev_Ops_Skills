#!/bin/bash

# Flush existing rules
iptables -F

# Set default policies to DROP
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

# Allow incoming SSH (port 22) and HTTP (port 80) traffic
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Allow established connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#git add simple_firewall.sh
#git commit -m "Add simple firewall script for Linux using iptables" is a simple message associated with the changes
#git push origin main

