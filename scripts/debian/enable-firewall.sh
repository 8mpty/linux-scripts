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

system_check() {
    echo
    echo -e "${GREEN}${BOLD}Detecting system type...${RESET}"
    if command -v apt &> /dev/null; then
        package_manager="apt"
        echo -e "${GREEN}${BOLD}Debian-based system detected (Using apt).${RESET}"
    elif command -v dnf &> /dev/null; then
        package_manager="dnf"
        echo -e "${GREEN}${BOLD}Fedora-based system detected (Using dnf).${RESET}"
    else
        echo -e "${RED}${BOLD}Unsupported distribution. Exiting...${RESET}"
        exit 1
    fi

    firewall_setup
}

firewall_setup(){
    $package_manager install gufw -y
 
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