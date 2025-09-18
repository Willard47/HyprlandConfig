#!/usr/bin/env bash

# Pick a random wallpaper
WALLPAPER=$(ls ~/Pictures/Wallpapers | shuf -n1)
swww img ~/Pictures/Wallpapers/"$WALLPAPER" --transition-fps 60

# Update Hyprland colors via Matugen
~/.config/scripts/workspace-colors.sh &

# Trigger dynamic Rofi theme update
# By touching a flag file
ROFI_THEME_FLAG="$HOME/.cache/rofi-theme-updated"
mkdir -p "$(dirname "$ROFI_THEME_FLAG")"
touch "$ROFI_THEME_FLAG"
