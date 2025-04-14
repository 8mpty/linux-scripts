#!/bin/sh

kitty & # Terminal
light-locker & # Light Locker
xfce4-screensaver & # Screensaver Locker

#systemctl --user enable --now pipewire pipewire-pulse wireplumber & # Audio
#systemctl --user enable --now bluetooth & # Bluetooth
#systemctl enable NetworkManager # Network

nm-applet --indicator & # Network
blueman-applet & # Bluetooth
xfce4-power-manager & # Power Manager | Display
# pasystray & # Audio Tray 

# Kill XFCE stuff whilst in Qtile session. User is still able to go to the base XFCE session and use a [XFCE] Desktop Environment if so chooses.
killall xfwm4
killall xfce4-panel
killall xfdesktop


# VMware Copy-Paste Fix (Debian) # sudo apt install open-vm-tools-desktop
/usr/bin/vmware-user-suid-wrapper