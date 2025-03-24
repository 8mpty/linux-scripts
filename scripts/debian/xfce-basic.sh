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

package_manager_choice() {
  read -p "Would you like to install using Nala (Y/n)? [default: y] " choice

  # If no input or any invalid input, default to 'y'
  case "${choice,,}" in
    [Yy]*)
      PM="nala"
      ;;
    [Nn]*)
      PM="apt"
      ;;
    *)
      echo -e "${YELLOW}No valid input detected. Defaulting to Nala.${RESET}"
      PM="nala"
      ;;
  esac
}

install_nala() {
    echo -e "${GREEN}${BOLD}Downloading Nala Script...${RESET}"
    apt install curl -y
    curl https://gitlab.com/volian/volian-archive/-/raw/main/install-nala.sh | bash

    echo -e "${GREEN}${BOLD}Updating System...${RESET}"
    apt update -y

    echo -e "${GREEN}${BOLD}Installing Nala...${RESET}"
    apt install nala -y

    echo -e "${GREEN}${BOLD}Setup completed successfully!${RESET}"
}

PACKAGE_LIST="git curl neofetch micro kitty xorg xserver-xorg-video-all xserver-xorg-input-all desktop-base xdg-utils fonts-symbola avahi-daemon libnss-mdns anacron eject iw alsa-utils sudo cups tasksel=3.73 lightdm light-locker xfce4-power-manager mousepad default-dbus-session-bus atril tango-icon-theme network-manager-gnome synaptic system-config-printer orca libxfce4ui-utils thunar xfce4-appfinder xfce4-panel xfce4-pulseaudio-plugin xfce4-session xfce4-settings xfconf xfdesktop4 xfwm4 mousepad thunar-archive-plugin thunar-media-tags-plugin xfce4-battery-plugin xfce4-clipman-plugin xfce4-cpufreq-plugin xfce4-cpugraph-plugin xfce4-dict xfce4-diskperf-plugin xfce4-fsguard-plugin xfce4-genmon-plugin xfce4-netload-plugin xfce4-notifyd xfce4-places-plugin xfce4-screenshooter xfce4-sensors-plugin xfce4-smartbookmark-plugin xfce4-systemload-plugin xfce4-taskmanager xfce4-timer-plugin xfce4-verve-plugin xfce4-wavelan-plugin xfce4-weather-plugin xfce4-whiskermenu-plugin xfce4-xkb-plugin"
PURGE_LIST="imagemagick"

# Function to install basic xfce stuff and some "goodies" from "xfce4-goodies"
install_xfce() {
  # Install Nala if chosen
  if [ "$PM" == "nala" ]; then
    install_nala
  fi

  echo -e "${GREEN}${BOLD}Installing Xfce...${RESET}"

  # Use (Nala or APT) to install the packages
  $PM install $PACKAGE_LIST -y
  $PM purge $PURGE_LIST -y

  sed -i 's/^#greeter-hide-users=false/greeter-hide-users=false/' /etc/lightdm/lightdm.conf

  echo -e "${GREEN}${BOLD}Setup completed successfully!${RESET}"
}

main() {
  check_root
  package_manager_choice
  install_xfce
}

main