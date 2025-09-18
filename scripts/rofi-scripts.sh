#!/usr/bin/env bash

THEME=$(~/.config/scripts/rofi-dynamic-theme.sh)

choice=$(rofi -dmenu -theme "$THEME" -p "Select Script:")

case "$choice" in
    "Change Wallpaper")
        ~/.config/scripts/change-wallpaper.sh
        ;;
    "Scratchpad")
        ~/.config/scripts/scratchpad.sh
        ;;
    "Backup Config")
        ~/.config/scripts/backup-config.sh
        ;;
    "Restore Config")
        BACKUP_PATH=$(rofi -dmenu -p "Backup Path:" -theme "$THEME")
        ~/.config/scripts/restore-config.sh "$BACKUP_PATH"
        ;;
    *)
        notify-send "Rofi Scripts" "No action selected or invalid option."
        ;;
esac

# Clean up temporary theme file
rm -f "$THEME"
