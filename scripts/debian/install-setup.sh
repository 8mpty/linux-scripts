#!/bin/bash

SCRIPT_SOURCE="FILE"
[ -t 0 ] || SCRIPT_SOURCE="PIPE"

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

check_script_exec(){
    if [ "$SCRIPT_SOURCE" = "PIPE" ]; then
        echo -e "${GREEN}${BOLD}Running from curl pipe. Setting up repository...${RESET}"
        TEMP_DIR=$(mktemp -d)
        echo -e "${GREEN}${BOLD}Cloning repository...${RESET}"

        git clone https://github.com/8mpty/linux-scripts.git "$TEMP_DIR" || {
            echo -e "${YELLOW}${BOLD}Failed to clone repository. Checking if git is installed...${RESET}"
            apt update && apt install git curl -y
            git clone https://github.com/8mpty/linux-scripts.git "$TEMP_DIR"
        }
        
        # Change to the scripts directory
        cd "$TEMP_DIR"
        git switch dev
        cd "scripts/debian"
        chmod +x *.sh
        echo -e "${GREEN}${BOLD}Repository set up. Running from: $(pwd)${RESET}"
    else
        echo -e "${GREEN}${BOLD}Running locally from: $0${RESET}"
    fi
}

install_dialog() {
    if ! command -v dialog &> /dev/null; then
        echo -e "${GREEN}${BOLD}Installing dialog package...${RESET}"
        apt-get update
        apt-get install -y dialog
    fi
}

run_enable_firewall() {
    echo -e "${GREEN}${BOLD}Installing ufw and Gufw...${RESET}"
    ./enable-firewall.sh
}

run_gnome_basic() {
    echo -e "${GREEN}${BOLD}Running gnome-basic.sh...${RESET}"
    ./gnome-basic.sh
}

run_xfce_basic() {
    echo -e "${GREEN}${BOLD}Running xfce-basic.sh...${RESET}"
    ./xfce-basic.sh
}

run_flatpak_debian() {
    echo -e "${GREEN}${BOLD}Running flatpak-debian.sh...${RESET}"
    bash -i ./flatpak-debian.sh
}

run_flathub_packages() {
    echo -e "${GREEN}${BOLD}Running flathub-packages.sh...${RESET}"
    ./flathub-packages.sh
}

# Will always be LAST in the menu
run_update_grub() {
    echo -e "${GREEN}${BOLD}Running update_grub_timeout.sh...${RESET}"
    ./update_grub_timeout.sh
}

show_menu() {
    tempfile=$(mktemp 2>/dev/null) || tempfile=/tmp/test$$
    trap 'rm -f $tempfile' 0 1 2 5 15

    dialog --backtitle "System Setup Options" \
           --title "Select Options To Run" \
           --checklist "Use SPACE to select/deselect options, ENTER to confirm:" 15 90 5 \
           "gnome-basic" " Install GNOME basic packages" OFF \
           "xfce-basic" " Install Xfce basic packages with some xfce4-goodies" OFF \
           "enable-firewall" " Setup and enable firewall" OFF \
           "flatpak-debian" " Install Flatpak for Debian" OFF \
           "flathub-packages" " Install Flathub packages" OFF \
           "update_grub_timeout" " Update GRUB timeout to 2secs" OFF \
           "reboot" " Reboot system (HIGHLY Recommended)" OFF \
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

    for option in $selected_formatted; do
        script_file="./$option.sh"
        if [ -f "$script_file" ]; then
            chmod +x "$script_file"
        fi
        case $option in
            "gnome-basic")
                run_gnome_basic
                ;;
            "xfce-basic")
                run_xfce_basic
                ;;
            "enable-firewall")
                run_enable_firewall
                ;;
            "flatpak-debian")
                run_flatpak_debian
                ;;
            "flathub-packages")
                run_flathub_packages
                ;;
            "update_grub_timeout")
                run_update_grub
                ;;
            "reboot")
                reboot
                ;;
        esac
    done
}

main() {
    check_root
    check_script_exec
    install_dialog
    show_menu
    echo
    echo -e "${GREEN}${BOLD}Setup completed successfully!${RESET}"
    rm -rf "$TEMP_DIR"
}

main