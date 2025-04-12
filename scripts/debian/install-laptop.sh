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

AUDIO_PKGS="pavucontrol pulseaudio"
SCREEN_PKGS="brightnessctl xfce4-power-manager"
BLUETOOTH_PKGS="bluez blueman"
NETWORK_PKGS="network-manager network-manager-gnome"

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
    echo -e "${GREEN}${BOLD}Successfully installed laptop utils.${RESET}"
}


main(){
    check_root
    configure_laptop_utils
}


main