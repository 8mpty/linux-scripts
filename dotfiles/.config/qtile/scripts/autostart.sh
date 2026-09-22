#!/bin/sh

kitty & # Terminal

#systemctl --user enable --now pipewire pipewire-pulse wireplumber & # Audio
#systemctl --user enable --now bluetooth & # Bluetooth
#systemctl enable NetworkManager # Network

# Network
nm-applet --indicator & 

# Bluetooth
blueman-applet & 

# Power Manager | Display
xfce4-power-manager & 

# Themeing
lxpolkit &

# Password/Authentication Prompts for sudo access
xsettingsd &

# Import display variables so portal services can access the X server
systemctl --user import-environment DISPLAY XAUTHORITY

# Restart portals after import
ystemctl --user restart xdg-desktop-portal.service
systemctl --user restart xdg-desktop-portal-gtk.service

# VMware Copy-Paste Fix (Debian) # sudo apt install open-vm-tools-desktop
/usr/bin/vmware-user-suid-wrapper