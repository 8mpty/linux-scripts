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
    echo -e "${YELLOW}${BOLD}This script requires root privileges.${RESET}"
    echo -e "${GREEN}Attempting to elevate privileges...${RESET}"
    
    # Try to use sudo to re-run the script
    if command -v sudo &> /dev/null; then
      echo -e "${YELLOW}${BOLD}Please enter your sudo password to continue.${RESET}"
      exec sudo -E bash "$0" "$@"
      exit $?
    else
      echo -e "${RED}${BOLD}Error: sudo is not installed. Cannot elevate privileges.${RESET}"
      echo "Please install sudo or run the script as root manually."
      exit 1
    fi
  fi
}

check_script_exec(){
    echo -e "${GREEN}${BOLD}Running from curl pipe. Setting up repository...${RESET}"
    TEMP_DIR=$(mktemp -d)
    echo -e "${GREEN}${BOLD}Cloning repository...${RESET}"

    git clone https://github.com/8mpty/linux-scripts.git "$TEMP_DIR" || {
        echo -e "${YELLOW}${BOLD}Failed to clone repository. Checking if git is installed...${RESET}"
        apt update && apt install git curl -y
        git clone https://github.com/8mpty/linux-scripts.git "$TEMP_DIR"
    }
    
    # Change to the scripts directory
    cd "$TEMP_DIR"
    git switch dev
    cd "scripts/debian"
    chmod +x install-setup.sh
    echo -e "${GREEN}${BOLD}Repository set up. Running from: $(pwd)${RESET}"
}

main(){
    check_root
    check_script_exec
    ./install-setup.sh
    rm -rf "$TEMP_DIR"
}

main