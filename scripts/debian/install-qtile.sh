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

# Maybe not needed?? (libxkbcommon-x11-dev, psutils, xserver-xorg, python3-v-sim)
OTHERS_LIST="git curl rofi kitty neofetch micro thunar sxiv xdg-utils"
PYTHON_LIST="python3 python3-venv python-dbus-dev"
QTILE_LIST="xorg xinit python3-pip libpangocairo-1.0-0 python3-xcffib python3-cairocffi"

install_dependencies(){
    echo
    echo -e "${GREEN}${BOLD}Installing Qtile Dependencies...${RESET}"
    apt update && apt install $OTHERS_LIST $PYTHON_LIST $QTILE_LIST -y
    echo -e "${GREEN}${BOLD}Finished installing of Qtile Dependencies...${RESET}"
}

configuration(){
    echo
    echo -e "${GREEN}${BOLD}Configuring Qtile...${RESET}"

    if ! sudo -u "$REAL_USER" bash -c '[ -d "$HOME/Desktop" ] && [ -d "$HOME/Documents" ] && [ -d "$HOME/Downloads" ]'; then
        echo -e "${GREEN}Creating XDG user directories...${RESET}"
        sudo -u "$REAL_USER" xdg-user-dirs-update
    else
        echo -e "${GREEN}XDG user directories already exist, skipping update.${RESET}"
    fi

    # Create necessary directories
    sudo -u "$REAL_USER" bash -c "mkdir -p \"$REAL_USER_HOME/.local/src\" && mkdir -p \"$REAL_USER_HOME/.local/bin\""

    # Set up the Python virtual environment
    sudo -u "$REAL_USER" bash -c "cd \"$REAL_USER_HOME/.local/src\" && python3 -m venv qtile_venv"

    # Clone Qtile repository
    sudo -u "$REAL_USER" bash -c "cd \"$REAL_USER_HOME/.local/src/qtile_venv\" "

    echo

    echo -e "${GREEN}${BOLD}Installing Python Packages...${RESET}"
    sudo -u "$REAL_USER" bash -c "\"$REAL_USER_HOME/.local/src/qtile_venv/bin/pip\" install qtile psutil"

    echo

    echo -e "${GREEN}${BOLD}Copying into $REAL_USER_HOME/.local/bin...${RESET}"
    sudo -u "$REAL_USER" bash -c "cp -rp \"$REAL_USER_HOME/.local/src/qtile_venv/bin/qtile\" \"$REAL_USER_HOME/.local/bin\""

    # Append to .bashrc only if the line doesn't already exist
    sudo -u "$REAL_USER" bash -c "
        if ! grep -qxF 'export PATH=\"$REAL_USER_HOME/.local/bin:\$PATH\"' \"$REAL_USER_HOME/.bashrc\"; then
            echo 'export PATH=\"$REAL_USER_HOME/.local/bin:\$PATH\"' >> \"$REAL_USER_HOME/.bashrc\"
        fi
        source \"$REAL_USER_HOME/.bashrc\"
    "
    
    # For Network Manager
    sed -i 's/^managed=false/managed=true/' /etc/NetworkManager/NetworkManager.conf
    service NetworkManager restart
}

configure_lightdm(){
    echo
    echo -e "${GREEN}${BOLD}Installing and Configuring LightDM...${RESET}"
    
    apt update && apt install lightdm -y

    systemctl enable lightdm

    echo -e "[Desktop Entry]\nName=Qtile\nComment=Qtile Session\nExec=$REAL_USER_HOME/.local/bin/qtile start\nType=Application\nKeywords=wm;tiling" > /usr/share/xsessions/qtile.desktop

    sed -i 's/^#greeter-hide-users=false/greeter-hide-users=false/' /etc/lightdm/lightdm.conf

    echo -e "${GREEN}${BOLD}LightDM configured to start Qtile.${RESET}"
}

main(){
    check_root
    #extra_decision
    install_dependencies
    configuration
}

main