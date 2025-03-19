#!/bin/bash

# Exit on any error
set -e

BOLD="\e[1m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}${BOLD}Please run this script with sudo privileges.${RESET}"
    exit 1
fi

flatpak_apps=(
    "flathub one.ablaze.floorp"
    #"flathub com.google.AndroidStudio"
)

installApps() {
    for app in "${flatpak_apps[@]}"; do
        echo "Installing $app..."
        sudo flatpak install $app
    done
}

installApps

echo "All applications have been installed."