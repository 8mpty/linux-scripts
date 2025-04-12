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

AUDIO_PKGS="pavucontrol pulseaudio"
SCREEN_PKGS="brightnessctl xfce4-power-manager"
BLUETOOTH_PKGS="bluez blueman"
NETWORK_PKGS="network-manager network-manager-gnome"
APPEARANCE_PKGS="libgtk-3-0 gnome-themes-extra lxappearance"
I3LOCK_COLOR_PKGS="autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev libgif-dev"
BETTERLOCKSCREEN_PKGS="bc imagemagick x11-xserver-utils x11-utils x11-xkb-utils"

configure_laptop_utils(){
    echo
    echo -e "${GREEN}${BOLD}Installing laptop utils...${RESET}"
    apt update

    echo
    echo -e "${GREEN}${BOLD}Installing Audio...${RESET}"
    #apt install pipewire pulseaudio-utils wireplumber pipewire-pulse pasystray -y
    #apt install --no-install-recommends pavucontrol -y
    
    # Installing Pulse Audio Controller & Pulseaudio
    apt install --no-install-recommends $AUDIO_PKGS -y

    echo
    echo -e "${GREEN}${BOLD}Installing Display | Brightness...${RESET}"
    apt install $SCREEN_PKGS -y

    #echo
    #echo -e "${GREEN}${BOLD}Installing Bluetooth...${RESET}"
    #apt install $BLUETOOTH_PKGS -y
    #systemctl enable bluetooth

    echo
    echo -e "${GREEN}${BOLD}Installing Network (Wifi | LAN)...${RESET}"
    
    # "Feature Packed" Network Manager (With GUI/CLI/Applet)
    apt install $NETWORK_PKGS -y
    systemctl enable NetworkManager.service

    # For Network Manager
    sed -i 's/^managed=false/managed=true/' /etc/NetworkManager/NetworkManager.conf
    service NetworkManager restart

    #echo
    #echo -e "${GREEN}${BOLD}Installing Screen Lock...${RESET}"
    #apt install light-locker -y

    echo
    echo -e "${GREEN}${BOLD}Installing lxappearance...${RESET}"
    apt install $APPEARANCE_PKGS -y

    echo
    echo -e "${GREEN}${BOLD}Installing & Setting up betterlockscreen and dependencies...${RESET}"
    apt install $I3LOCK_COLOR_PKGS $BETTERLOCKSCREEN_PKGS -y
    
    # Check if i3lock-color directory exists and remove it if it does
    if [ -d "/home/$REAL_USER/i3lock-color" ]; then
        echo -e "${YELLOW}${BOLD}Removing existing i3lock-color directory...${RESET}"
        sudo rm -rf "/home/$REAL_USER/i3lock-color"
    fi

    wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system

    echo
    echo -e "${GREEN}${BOLD}Successfully installed laptop utils.${RESET}"
}

main(){
    check_root
    configure_laptop_utils
}

main