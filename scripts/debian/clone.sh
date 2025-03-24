#!/bin/bash

# Exit on any error
set -e

BOLD="\e[1m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

check_script_exec(){
    echo -e "${GREEN}${BOLD}Running from curl pipe. Setting up repository...${RESET}"
    echo -e "${GREEN}${BOLD}Cloning repository...${RESET}"

    git clone https://github.com/8mpty/linux-scripts.git || {
        echo -e "${YELLOW}${BOLD}Failed to clone repository. Checking if git is installed...${RESET}"
        apt update && apt install git curl -y
        git clone https://github.com/8mpty/linux-scripts.git
    }
    
    # Change to the scripts directory
    cd "linux-scripts"
    git switch dev
    cd "scripts/debian"
    chmod +x install-setup.sh
    echo -e "${GREEN}${BOLD}Repository set up. Running from: $(pwd)${RESET}"
}

main(){
    check_script_exec
    ./install-setup.sh
}

main