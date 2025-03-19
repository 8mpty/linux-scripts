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

# Function to install Gnome-Core
install_gnome() {
  echo -e "${GREEN}${BOLD}Installing Gnome-Core...${RESET}"
  apt install gnome-core -y
}

main() {
  check_root
  install_gnome
}

main