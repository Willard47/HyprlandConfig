#!/usr/bin/env bash
set -e

DEBUG=true  # always print what we are doing

UPDATE_ONLY=false
for arg in "$@"; do
    [[ "$arg" == "--update" ]] && UPDATE_ONLY=true
done

CONFIG_REPO="https://github.com/Willard47/HyprlandConfig.git"
CONFIG_TEMP_DIR="$HOME/.cache/HyprlandConfig"

echo "📥 Cloning repo..."
rm -rf "$CONFIG_TEMP_DIR"
git clone --depth=1 "$CONFIG_REPO" "$CONFIG_TEMP_DIR"

if [ ! -d "$CONFIG_TEMP_DIR/.config" ]; then
    echo "❌ ERROR: .config folder not found in repo!"
    exit 1
fi

mkdir -p "$HOME/.config"

echo "📂 Copying configs..."
for f in "$CONFIG_TEMP_DIR/.config/"*; do
    echo "Copying $f -> ~/.config/"
    cp -rf "$f" "$HOME/.config/"
done

# Scripts folder
if [ -d "$CONFIG_TEMP_DIR/.config/scripts" ]; then
    echo "🔧 Updating scripts..."
    rm -rf "$HOME/.config/scripts"
    cp -rf "$CONFIG_TEMP_DIR/.config/scripts" "$HOME/.config/scripts"
    find "$HOME/.config/scripts" -type f -exec chmod +x {} \;
fi

# Wallpapers
if [ -d "$CONFIG_TEMP_DIR/wallpapers" ]; then
    mkdir -p "$HOME/Pictures/wallpapers"
    echo "🖼 Copying wallpapers..."
    for wp in "$CONFIG_TEMP_DIR/wallpapers/"*; do
        echo "Copying $wp -> ~/Pictures/wallpapers/"
        cp -rf "$wp" "$HOME/Pictures/wallpapers/"
    done
fi

# Set wallpaper/colors
if [ -f "$HOME/.config/scripts/change-wallpaper.sh" ]; then
    WALLPAPER=$(find "$HOME/Pictures/wallpapers" -type f | head -n 1)
    [ -n "$WALLPAPER" ] && bash "$HOME/.config/scripts/change-wallpaper.sh" "$WALLPAPER"
fi

echo "✅ Configs copied successfully!"
