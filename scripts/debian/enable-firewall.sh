#!/bin/bash

# Exit on any error
set -e

BOLD="\e[1m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

# Function to check if script is running with root privileges
check_root() {
  if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}${BOLD}Please run this script with sudo privileges.${RESET}"
    exit 1
  fi
}

firewall_setup(){
    apt install gufw -y
 
    # Firewall rules
    ufw limit 22/tcp
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw default deny incoming
    ufw default allow outgoing
 
    # Enable firewall
    ufw enable
 
    # Display firewall status
    ufw status
}

main(){
    firewall_setup
}

main