#!/usr/bin/env bash

# Location to store wallpapers locally
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
mkdir -p "$WALLPAPER_DIR"

# URL of the wallpaper in your GitHub repo
# Replace with your actual repo and file path
WALLPAPER_URL="https://raw.githubusercontent.com/Willard47/HyprlandConfig/main/wallpapers/default.jpg"

# Local destination
LOCAL_WALLPAPER="$WALLPAPER_DIR/default.jpg"

echo "📥 Downloading wallpaper from GitHub..."
curl -fsSL "$WALLPAPER_URL" -o "$LOCAL_WALLPAPER"

# Start swww if not already running
if ! pgrep -x "swww-daemon" > /dev/null; then
    echo "🚀 Starting swww-daemon..."
    swww-daemon &
    sleep 0.5
fi

echo "🖼 Setting wallpaper..."
swww img "$LOCAL_WALLPAPER" --transition-type grow --transition-fps 60 --transition-duration 1

# Run Matugen to generate theme colors (if installed)
if command -v matugen &>/dev/null; then
    echo "🎨 Generating dynamic colors..."
    matugen image "$LOCAL_WALLPAPER" --alpha 0.5 --output "$HOME/.config/hypr/colors.conf"
else
    echo "⚠️ Matugen not found, skipping color generation."
fi

# Reload Hyprland config and bars to apply new theme
echo "🔄 Reloading Hyprland and bars..."
hyprctl reload
pkill -USR2 waybar 2>/dev/null || true
pkill -USR2 warbar 2>/dev/null || true
pkill -USR2 swaync 2>/dev/null || true

echo "✅ Wallpaper and colors updated successfully."
