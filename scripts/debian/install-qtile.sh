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

OTHERS_LIST="git curl rofi lightdm kitty"
QTILE_LIST="xorg xserver-xorg xinit python3 python3-pip python3-venv python3-v-sim python-dbus-dev python3-xcffib python3-cairocffi libpangocairo-1.0-0 libxkbcommon-x11-dev sxiv"

install_dependencies(){
    echo
    echo -e "${GREEN}${BOLD}Installing Qtile Dependencies...${RESET}"
    apt update && apt install $OTHERS_LIST $QTILE_LIST -y
    echo -e "${GREEN}${BOLD}Finished installing of Qtile Dependencies...${RESET}"
}

# Maybe install pulsectl-asyncio???
configuration(){
    echo
    echo -e "${GREEN}${BOLD}Configuring Qtile...${RESET}"

    sudo -u "$REAL_USER" xdg-user-dirs-update

    # Create necessary directories
    sudo -u "$REAL_USER" bash -c "mkdir -p \"$REAL_USER_HOME/.local/src\" && mkdir -p \"$REAL_USER_HOME/.local/bin\""

    # Set up the Python virtual environment
    sudo -u "$REAL_USER" bash -c "cd \"$REAL_USER_HOME/.local/src\" && python3 -m venv qtile_venv"

    # Clone Qtile repository
    sudo -u "$REAL_USER" bash -c "cd \"$REAL_USER_HOME/.local/src/qtile_venv\" && rm -rf qtile/ && git clone https://github.com/qtile/qtile.git"

    echo

    echo -e "${GREEN}${BOLD}Installing Python Packages...${RESET}"
    sudo -u "$REAL_USER" bash -c "\"$REAL_USER_HOME/.local/src/qtile_venv/bin/pip\" install \"$REAL_USER_HOME/.local/src/qtile_venv/qtile/.\" qtile-extras psutils"

    echo

    echo -e "${GREEN}${BOLD}Copying into $REAL_USER_HOME/.local/bin...${RESET}"
    sudo -u "$REAL_USER" bash -c "rm -rf \"$REAL_USER_HOME/.local/bin/qtile\" && cp -rp \"$REAL_USER_HOME/.local/src/qtile_venv/bin/qtile\" \"$REAL_USER_HOME/.local/bin\""

    # Append to .bashrc only if the line doesn't already exist
    sudo -u "$REAL_USER" bash -c "
        if ! grep -qxF 'export PATH=\"$REAL_USER_HOME/.local/bin:\$PATH\"' \"$REAL_USER_HOME/.bashrc\"; then
            echo 'export PATH=\"$REAL_USER_HOME/.local/bin:\$PATH\"' >> \"$REAL_USER_HOME/.bashrc\"
        fi
        source \"$REAL_USER_HOME/.bashrc\"
    "
}


configure_lightdm(){
    echo
    echo -e "${GREEN}${BOLD}Configuring LightDM...${RESET}"
    
    systemctl enable lightdm

    echo -e "[Desktop Entry]\nName=Qtile\nComment=Qtile Session\nExec=$REAL_USER_HOME/.local/bin/qtile start\nType=Application\nKeywords=wm;tiling" > /usr/share/xsessions/qtile.desktop

    echo -e "${GREEN}${BOLD}LightDM configured to start Qtile.${RESET}"
}

main(){
    check_root
    install_dependencies
    configuration
    configure_lightdm
}

main