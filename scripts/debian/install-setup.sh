#!/bin/bash

SCRIPT_SOURCE="FILE"
[ -t 0 ] || SCRIPT_SOURCE="PIPE"

# Exit on any error
set -e

BOLD="\e[1m"
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

# List of excluded script files
EXCLUDE_SCRIPTS=("clone.sh" "$(basename "$0")")

# Function to check if script is running with root privileges
check_root() {
  if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}${BOLD}This script requires root privileges.${RESET}"
    echo -e "${GREEN}Attempting to elevate privileges...${RESET}"
    
    if command -v sudo &> /dev/null; then
      echo -e "${YELLOW}${BOLD}Please enter your sudo password to continue.${RESET}"
      exec sudo -E bash "$0" "$@"
      exit $?
    else
      echo -e "${RED}${BOLD}Error: sudo is not installed. Cannot elevate privileges.${RESET}"
      echo "Please install sudo or run the script as root manually."
      exit 1
    fi
  fi
}

install_dialog() {
    if ! command -v dialog &> /dev/null; then
        echo -e "${GREEN}${BOLD}Installing dialog package...${RESET}"
        apt update
        apt install -y dialog
    fi
}

run_reboot() {
    echo -e "${GREEN}${BOLD}Rebooting in 5 seconds. Press Ctrl + C NOW to cancel!${RESET}"
    sleep 5
    reboot
}

show_menu() {
    tempfile=$(mktemp 2>/dev/null) || tempfile=/tmp/test$$
    trap 'rm -f $tempfile' 0 1 2 5 15

    menu_items=()

    # Include .sh scripts except excluded ones
    for script in ./*.sh; do
        [ -f "$script" ] || continue

        base=$(basename "$script")
        skip=false
        for exclude in "${EXCLUDE_SCRIPTS[@]}"; do
            if [[ "$base" == "$exclude" ]]; then
                skip=true
                break
            fi
        done
        
        if [[ "$base" == dev-*.sh ]]; then
            skip=true
        fi

        $skip && continue

        name="${base%.sh}"
        description="Run $name script"
        menu_items+=("$name" "$description" OFF)
    done

    # Display dialog with menu_items
    dialog --backtitle "System Setup Options" \
           --title "Select Scripts to Run" \
           --checklist "Use SPACE to select/deselect scripts, ENTER to confirm:" 20 80 12 \
           "${menu_items[@]}" \
           "reboot" "Reboot the system" OFF 2> "$tempfile"

    if [ $? -ne 0 ]; then
        echo -e "${YELLOW}${BOLD}Setup canceled by user.${RESET}"
        exit 0
    fi

    selected=$(<"$tempfile")
    selected_formatted=$(echo $selected | tr -d '"')

    if [ -z "$selected_formatted" ]; then
        dialog --title "No Selection" --msgbox "No scripts were selected. Exiting." 8 40
        exit 0
    fi

    dialog --title "Confirm Selection" \
           --yesno "Are you sure you want to execute the following scripts?\n\n$selected_formatted" 10 60

    if [ $? -ne 0 ]; then
        echo -e "${YELLOW}${BOLD}Setup canceled by user at confirmation.${RESET}"
        exit 0
    fi

    for item in $selected_formatted; do
        case "$item" in
            reboot)
                run_reboot
                ;;
            *)
                script_path="./$item.sh"
                if [ -f "$script_path" ]; then
                    echo -e "${GREEN}${BOLD}Running $script_path...${RESET}"
                    chmod +x "$script_path"
                    "$script_path"
                else
                    echo -e "${YELLOW}${BOLD}Warning: $script_path not found.${RESET}"
                fi
                ;;
        esac
    done
}

main() {
    check_root
    install_dialog
    show_menu
    echo
    echo -e "${GREEN}${BOLD}Setup completed successfully!${RESET}"
}

main
