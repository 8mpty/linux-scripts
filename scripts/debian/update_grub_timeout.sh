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

main(){
    check_root
    sudo sed -i 's/^GRUB_TIMEOUT=5/GRUB_TIMEOUT=2/' /etc/default/grub && sudo update-grub
    echo
    echo -e "${YELLOW}${BOLD}It's recommended to restart your system for changes to take full effect.${RESET}"
}

main