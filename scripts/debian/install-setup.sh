#!/bin/bash

SCRIPT_SOURCE="FILE"
[ -t 0 ] || SCRIPT_SOURCE="PIPE"

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

install_dialog() {
    if ! command -v dialog &> /dev/null; then
        echo -e "${GREEN}${BOLD}Installing dialog package...${RESET}"
        apt-get update
        apt-get install -y dialog
    fi
}

setup_firewall() {
    echo -e "${GREEN}${BOLD}Installing ufw and Gufw...${RESET}"
    apt install gufw -y
 
    # Firewall rules
    ufw limit 22/tcp
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw default deny incoming
    ufw default allow outgoing
 
    # Enable firewall
    ufw enable
 
    # Display firewall status
    ufw status
}

run_gnome_basic() {
    echo -e "${GREEN}${BOLD}Running gnome-basic.sh...${RESET}"
    ./gnome-basic.sh
}

run_flatpak_debian() {
    echo -e "${GREEN}${BOLD}Running flatpak-debian.sh...${RESET}"
    ./flatpak-debian.sh
}

run_flathub_packages() {
    echo -e "${GREEN}${BOLD}Running flathub-packages.sh...${RESET}"
    ./flathub-packages.sh
}

show_menu() {
    tempfile=$(mktemp 2>/dev/null) || tempfile=/tmp/test$$
    trap 'rm -f $tempfile' 0 1 2 5 15

    dialog --backtitle "System Setup Options" \
           --title "Select Options To Run" \
           --checklist "Use SPACE to select/deselect options, ENTER to confirm:" 15 60 5 \
           "gnome-basic" "Install GNOME basic packages" OFF \
           "enable-firewall" "Setup and enable firewall" OFF \
           "install-flatpak" "Install Flatpak for Debian" OFF \
           "install-flathub-pkg" "Install Flathub packages" OFF \
           2> $tempfile

    if [ $? -ne 0 ]; then
        echo -e "${YELLOW}${BOLD}Setup canceled by user.${RESET}"
        exit 0
    fi

    selected=$(cat $tempfile)

    selected_formatted=$(echo $selected | tr -d '"')
    if [ -z "$selected_formatted" ]; then
        dialog --title "No Selection" --msgbox "No options were selected. Exiting." 8 40
        exit 0
    fi

    dialog --title "Confirm Selection" \
           --yesno "Are you sure you want to execute the following options?\n\n$selected_formatted" 10 60

    if [ $? -ne 0 ]; then
        echo -e "${YELLOW}${BOLD}Setup canceled by user at confirmation.${RESET}"
        exit 0
    fi

    for option in $(cat $tempfile); do
        option=$(echo $option | tr -d '"')
        case $option in
            "gnome-basic")
                run_gnome_basic
                ;;
            "enable-firewall")
                setup_firewall
                ;;
            "install-flatpak")
                run_flatpak_debian
                ;;
            "install-flathub-pkg")
                run_flathub_packages
                ;;
        esac
    done

    dialog --title "Setup Complete" --msgbox "All selected operations have been completed." 8 40
}

main() {
    install_dialog
    show_menu
    echo -e "${GREEN}${BOLD}Setup completed successfully!${RESET}"
}

main