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

task_desktop="tasksel xorg xserver-xorg-video-all xserver-xorg-input-all"
task_dekstop_rec="xdg-utils fonts-symbola avahi-daemon libnss-mdns anacron eject iw alsa-utils sudo"
base_list="desktop-base xfce4"
custom_goodies="xfce4-battery-plugin xfce4-clipman-plugin xfce4-diskperf-plugin xfce4-genmon-plugin xfce4-netload-plugin xfce4-notifyd xfce4-places-plugin xfce4-screenshooter xfce4-wavelan-plugin xfce4-whiskermenu-plugin"
op_list="neofetch kitty curl git"
utils_list="network-manager blueman"

system_check() {
    echo
    echo -e "${GREEN}${BOLD}Detecting system type...${RESET}"
    if command -v apt &> /dev/null; then
        package_manager="apt"
        echo -e "${GREEN}${BOLD}Debian-based system detected (Using apt).${RESET}"
    elif command -v dnf &> /dev/null; then
        package_manager="dnf"
        echo -e "${GREEN}${BOLD}Fedora-based system detected (Using dnf).${RESET}"
    else
        echo -e "${RED}${BOLD}Unsupported distribution. Exiting...${RESET}"
        exit 1
    fi

    start_install
}

start_install(){
    echo
    echo -e "${GREEN}${BOLD}Installing Custom XFCE...${RESET}"
    
    $package_manager update && $package_manager install $task_desktop $task_dekstop_rec $base_list $custom_goodies -y
    sed -i 's/^#greeter-hide-users=false/greeter-hide-users=false/' /etc/lightdm/lightdm.conf

    echo
    echo -e "${GREEN}${BOLD}Setup completed successfully!${RESET}"
}

main(){
    check_root
    system_check
}

main