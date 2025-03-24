#!/bin/bash

SCRIPT_SOURCE="FILE"
[ -t 0 ] || SCRIPT_SOURCE="PIPE"

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

check_script_exec(){
    if [ "$SCRIPT_SOURCE" = "PIPE" ]; then
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
    else
        echo -e "${GREEN}${BOLD}Running locally from: $0${RESET}"
    fi
}


main(){
    check_script_exec
    ./install-setup.sh
}

main