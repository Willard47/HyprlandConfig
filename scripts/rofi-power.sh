#!/usr/bin/env bash

THEME=$(~/.config/scripts/rofi-dynamic-theme.sh)

choice=$(rofi -dmenu -theme "$THEME" -p "Power Menu:")

case "$choice" in
    "Shutdown") systemctl poweroff ;;
    "Reboot") systemctl reboot ;;
    "Suspend") systemctl suspend ;;
    "Logout") hyprctl dispatch exit ;;
    *) notify-send "Power Menu" "No action selected or invalid option." ;;
esac

rm -f "$THEME"
