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

install_flatpak_repo(){
  echo -e "${GREEN}${BOLD}Installing Flatpak...${RESET}"
  apt update
  apt install -y flatpak

  # Detect desktop environment
  if [ -n "$XDG_CURRENT_DESKTOP" ]; then
    DE=$XDG_CURRENT_DESKTOP
  else
    if [ -n "$(pgrep gnome-shell)" ]; then
      DE="GNOME"
    elif [ -n "$(pgrep plasmashell)" ]; then
      DE="KDE"
    else
      DE="UNKNOWN"
    fi
  fi

  case $DE in
    *GNOME*)
      echo -e "${GREEN}${BOLD}Detected GNOME desktop environment.${RESET}"
      echo -e "${GREEN}${BOLD}Installing GNOME Software Flatpak plugin...${RESET}"
      apt install -y gnome-software-plugin-flatpak
      ;;
    *KDE*)
      echo -e "${GREEN}${BOLD}Detected KDE desktop environment.${RESET}"
      echo -e "${GREEN}${BOLD}Installing Discover Flatpak backend...${RESET}"
      apt install -y plasma-discover-backend-flatpak
      ;;
    *)
      echo -e "${YELLOW}${BOLD}Desktop environment is not GNOME or KDE.${RESET}"
      echo -e "${YELLOW}${BOLD}Skipping desktop integration installation.${RESET}"
      ;;
  esac

  # Add Flathub repository
  echo -e "${GREEN}${BOLD}Adding Flathub repository...${RESET}"
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  # Get the current username and home directory dynamically
  USERNAME=$(whoami)
  HOMEDIR=$(eval echo ~$USERNAME)

  # Fix permissions for Flatpak repository
  echo -e "${GREEN}${BOLD}Fixing Flatpak repository permissions...${RESET}"
  sudo chown -R "$USERNAME:$USERNAME" "$HOMEDIR/.local/share/flatpak"
  sudo chmod -R u+rw "$HOMEDIR/.local/share/flatpak"

  echo -e "${GREEN}${BOLD}Setup completed successfully!${RESET}"
  echo -e "To install applications from Flathub, use your software center or run:"
  echo -e "  flatpak install flathub <application-id>"

  echo
  echo -e "${YELLOW}${BOLD}It's recommended to restart your system for changes to take full effect and required to install flathub packages.${RESET}"
}

# Ask if user wants to reboot
test_ask_reboot(){
  read -t 10 -p "Would you like to reboot now? (y/N): " choice
  echo
  choice=${choice:-n}

  case "$choice" in
    y|Y|yes|Yes|YES )
      echo "System will reboot now...."
      shutdown -r now
      ;;
    * )
      echo "Skipping reboot. You may want to log out and back in for changes to take effect."
      ;;
  esac
}

main(){
  check_root
  install_flatpak_repo
  # test_ask_reboot
}

main
