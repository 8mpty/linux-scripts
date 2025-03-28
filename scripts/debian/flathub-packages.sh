#!/bin/bash

# Exit on any error
set -e

BOLD="\e[1m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

check_root() {
  if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}${BOLD}Please run this script with sudo privileges.${RESET}"
    exit 1
  fi
}

flatpak_apps=(
    #"one.ablaze.floorp",
    #"com.mattjakeman.ExtensionManager",
    #"com.google.AndroidStudio",
    app.zen_browser.zen
)

installApps() {
  # Get the current username and home directory dynamically
  USERNAME=$(logname)
  HOMEDIR=$(eval echo ~"$REAL_USER")

  # fix_flatpak_dir

  for app in "${flatpak_apps[@]}"; do
    echo "Installing $app..."
    flatpak install flathub $app -y
  done
}

fix_flatpak_dir(){
  # Fix permissions for Flatpak repository
  echo -e "${GREEN}${BOLD}Fixing Flatpak repository permissions...${RESET}"

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
    installApps
}

main
echo "All applications have been installed."