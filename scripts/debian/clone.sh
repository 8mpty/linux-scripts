#!/bin/bash

# Exit on any error
set -e

BOLD="\e[1m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

check_script_exec(){
    echo -e "${GREEN}${BOLD}Running from curl pipe. Setting up repository...${RESET}"
    TEMP_DIR=$(mktemp -d)
    echo -e "${GREEN}${BOLD}Cloning repository...${RESET}"

    git clone https://github.com/8mpty/linux-scripts.git "$TEMP_DIR" || {
        echo -e "${YELLOW}${BOLD}Failed to clone repository. Checking if git is installed...${RESET}"
        sudo apt update && sudo apt install git curl -y
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
    check_script_exec
    ./install-setup.sh
    rm -rf "$TEMP_DIR"
}

main