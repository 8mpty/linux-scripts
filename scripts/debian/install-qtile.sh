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

# Get the real user who invoked sudo
REAL_USER=$(logname)
REAL_USER_HOME=$(eval echo ~"$REAL_USER")

DEP_LIST="xserver-xorg xinit python3-pip python3-xcffib python3-cairocffi python3-venv libpangocairo-1.0-0 python3-v-sim rofi"

install_dependencies(){
    echo
    echo -e "${GREEN}${BOLD}Installing Qtile Dependencies...${RESET}"
    apt update && apt install $DEP_LIST -y
    echo -e "${GREEN}${BOLD}Finished installing of Qtile Dependencies...${RESET}"
}

configuration(){
    echo
    echo -e "${GREEN}${BOLD}Configuring Qtile...${RESET}"
    
    # Use sudo -u to run commands as the real user
    sudo -u "$REAL_USER" bash << EOF
    mkdir -p "$REAL_USER_HOME/.local/src" && mkdir -p "$REAL_USER_HOME/.local/bin"
    cd "$REAL_USER_HOME/.local/src"
    python3 -m venv qtile_venv
    cd qtile_venv
    rm -rf qtile/
    git clone https://github.com/qtile/qtile.git
    echo -e "${GREEN}${BOLD}Installing Python Packages...${RESET}"
    "$REAL_USER_HOME/.local/src/qtile_venv/bin/pip" install qtile psutils pulsectl-asyncio
    echo -e "${GREEN}${BOLD}Copying into $REAL_USER_HOME/.local/bin...${RESET}"
    rm -rf $REAL_USER_HOME/.local/bin/qtile
    cp -rp ./bin/qtile "$REAL_USER_HOME/.local/bin"
    
    # Append to .bashrc only if the line doesn't already exist
    if ! grep -qxF "export PATH=\"$REAL_USER_HOME/.local/bin:\$PATH\"" "$REAL_USER_HOME/.bashrc"; then
        echo "export PATH=\"$REAL_USER_HOME/.local/bin:\$PATH\"" >> "$REAL_USER_HOME/.bashrc"
    fi
    source "$REAL_USER_HOME/.bashrc"
EOF

    # echo -e "${GREEN}${BOLD}Modifying new session for Qtile...${RESET}"    
    # # Use the real user's home directory in the Exec line
    # echo -e "[Desktop Entry]\nName=Qtile\nComment=Qtile Session\nExec=$REAL_USER_HOME/.local/bin/qtile start\nType=Application\nKeywords=wm;tiling" > /usr/share/xsessions/qtile.desktop
    
    # echo -e "${GREEN}${BOLD}Successfully configured Qtile and Paths...${RESET}"
    # echo -e "${YELLOW}${BOLD}It's recommended to restart your system for changes to take full effect.${RESET}"
}

main(){
    check_root
    install_dependencies
    configuration
}

main