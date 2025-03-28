#!/bin/sh

lock_screen() {
    if command -v xflock4 >/dev/null 2>&1; then
        xflock4
    elif command -v i3lock >/dev/null 2>&1; then
        i3lock
    elif command -v betterlockscreen >/dev/null 2>&1; then
        betterlockscreen -l
    elif command -v light-locker-command >/dev/null 2>&1; then
        light-locker-command -l
    else
        notify-send "No lock command found"
    fi
}

chosen=$(printf "Shutdown\nReboot\nLog Out\nLock" | rofi -dmenu -i -p "Power Menu" -theme-str '@import "./custom.rasi"' -theme-str 'entry { placeholder: ""; }' )

case "$chosen" in
    "Shutdown") systemctl poweroff ;;
    "Reboot") systemctl reboot ;;
    "Log Out") pkill -KILL -u $USER ;;
    "Lock") lock_screen ;;
    *) exit 1 ;;
esac
