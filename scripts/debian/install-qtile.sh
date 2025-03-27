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

extra_decision() {
  read -t 5 -p "Would you like to install laptop utils (bluetooth, wifi etc.)? [default: y] " lapchoice
  read -t 5 -p "Would you like to auto install and configure lightdm? [default: y] " ldmchoice

  # If no input or any invalid input, default to 'y'
  case "${lapchoice,,}" in
    [Yy]*)
      lapchoice="true"
      ;;
    [Nn]*)
      lapchoice="false"
      ;;
    *)
      echo -e "${YELLOW}No valid input detected. Defaulting to Y.${RESET}"
      lapchoice="true"
      ;;
  esac
  
  # If no input or any invalid input, default to 'y'
  case "${ldmchoice,,}" in
    [Yy]*)
      ldmchoice="true"
      ;;
    [Nn]*)
      ldmchoice="false"
      ;;
    *)
      echo -e "${YELLOW}No valid input detected. Defaulting to Y.${RESET}"
      ldmchoice="true"
      ;;
  esac
}

# Get the real user who invoked sudo
REAL_USER=$(logname)
REAL_USER_HOME=$(eval echo ~"$REAL_USER")

OTHERS_LIST="git curl rofi kitty neofetch micro thunar"
PYTHON_LIST="python3 python3-pip python3-venv python3-v-sim python-dbus-dev python3-xcffib python3-cairocffi"
QTILE_LIST="xorg xserver-xorg xinit xdg-utils libpangocairo-1.0-0 libxkbcommon-x11-dev sxiv psutils"

install_dependencies(){
    echo
    echo -e "${GREEN}${BOLD}Installing Qtile Dependencies...${RESET}"
    apt update && apt install --no-install-recommends $OTHERS_LIST $PYTHON_LIST $QTILE_LIST -y
    echo -e "${GREEN}${BOLD}Finished installing of Qtile Dependencies...${RESET}"
}

configuration(){
    echo
    echo -e "${GREEN}${BOLD}Configuring Qtile...${RESET}"

    sudo -u "$REAL_USER" xdg-user-dirs-update

    # Create necessary directories
    sudo -u "$REAL_USER" bash -c "mkdir -p \"$REAL_USER_HOME/.local/src\" && mkdir -p \"$REAL_USER_HOME/.local/bin\""

    # Set up the Python virtual environment
    sudo -u "$REAL_USER" bash -c "cd \"$REAL_USER_HOME/.local/src\" && python3 -m venv qtile_venv"

    # Clone Qtile repository
    sudo -u "$REAL_USER" bash -c "cd \"$REAL_USER_HOME/.local/src/qtile_venv\" "

    echo

    echo -e "${GREEN}${BOLD}Installing Python Packages...${RESET}"
    sudo -u "$REAL_USER" bash -c "\"$REAL_USER_HOME/.local/src/qtile_venv/bin/pip\" install qtile qtile-extras psutil"

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
}

configure_laptop_utils(){
    echo
    echo -e "${GREEN}${BOLD}Installing laptop utils...${RESET}"
    apt update

    echo
    echo -e "${GREEN}${BOLD}Installing Audio...${RESET}"
    apt install pipewire pipewire-pulse wireplumber pasystray -y
    apt install --no-install-recommends pavucontrol -y

    echo
    echo -e "${GREEN}${BOLD}Installing Display | Brightness...${RESET}"
    apt install brightnessctl xfce4-power-manager -y

    echo
    echo -e "${GREEN}${BOLD}Installing Bluetooth...${RESET}"
    apt install blueman -y

    echo
    echo -e "${GREEN}${BOLD}Installing Network (Wifi | LAN)...${RESET}"
    apt install network-manager -y

    echo
    echo -e "${GREEN}${BOLD}Installing Screen Lock...${RESET}"
    apt install light-locker -y

    echo
    echo -e "${GREEN}${BOLD}Successfully installed laptop utils.${RESET}"
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

disclaimers(){
    echo -e "${YELLOW}${BOLD}Installation Finished!.${RESET}"
    echo -e "${YELLOW}${BOLD}Please do the necessary configuration if you already have a Desktop Environment Installed.${RESET}"
}

main(){
    check_root
    extra_decision
    install_dependencies
    configuration
    if [ "$lapchoice" == "true" ]; then
        configure_laptop_utils
    fi

    if [ "$ldmchoice" == "true" ]; then
        configure_lightdm
    fi

    # END
    disclaimers
}

main