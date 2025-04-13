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
  sudo -u "$REAL_USER" bash -c "flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo"

  echo -e "${GREEN}${BOLD}Setup completed successfully!${RESET}"
  echo -e "To install applications from Flathub, use your software center or run:"
  echo -e "  flatpak install flathub <application-id>"

  echo
  echo -e "${YELLOW}${BOLD}It's recommended to restart your system for changes to take full effect and required to install flathub packages.${RESET}"
}

fix_flatpak_dir(){
  # Fix permissions for Flatpak repository
  echo -e "${GREEN}${BOLD}Fixing Flatpak repository permissions...${RESET}"

  # fix_flatpak_dir
  FLATPAK_DIR="$HOMEDIR/.local/share/flatpak"
  if [ -d "$FLATPAK_DIR" ]; then
    chown -R "$USERNAME:$USERNAME" "$FLATPAK_DIR"
    chmod -R u+rw "$FLATPAK_DIR"
  else
    echo -e "${YELLOW}${BOLD}Skipping: $FLATPAK_DIR does not exist.${RESET}"
  fi
}

main(){
  check_root
  install_flatpak_repo
  # test_ask_reboot
}

main
