#!/usr/bin/env bash
set -e

# -----------------------------------------------------------------------------
# Check if running as update-only
# -----------------------------------------------------------------------------
UPDATE_ONLY=false
if [[ "$1" == "--update" ]]; then
    UPDATE_ONLY=true
    echo "🔄 Running in UPDATE mode (will only pull latest configs)"
fi

# -----------------------------------------------------------------------------
# Install dependencies (only on fresh installs)
# -----------------------------------------------------------------------------
if [ "$UPDATE_ONLY" = false ]; then
    echo "📦 Installing base packages..."
    sudo pacman -Syu --needed --noconfirm \
        hyprland waybar swaync swww \
        rofi wlogout hyprlock \
        starship neovim \
        ttf-nerd-fonts-symbols \
        curl git unzip wget jq \
        wl-clipboard grim slurp playerctl \
        python-pip
fi

# -----------------------------------------------------------------------------
# Pull latest configs from GitHub
# -----------------------------------------------------------------------------
CONFIG_REPO="https://github.com/Willard47/HyprlandConfig.git"
CONFIG_TEMP_DIR="$HOME/.cache/HyprlandConfig"

echo "📥 Pulling latest configs from $CONFIG_REPO..."
rm -rf "$CONFIG_TEMP_DIR"
git clone --depth=1 "$CONFIG_REPO" "$CONFIG_TEMP_DIR"

echo "📂 Copying configs to ~/.config..."
mkdir -p ~/.config
cp -rf "$CONFIG_TEMP_DIR/.config/"* ~/.config/

# Ensure scripts are executable
echo "🔧 Making scripts executable..."
find ~/.config/scripts -type f -exec chmod +x {} \;

# -----------------------------------------------------------------------------
# Download wallpapers if present
# -----------------------------------------------------------------------------
if [ "$UPDATE_ONLY" = false ] && [ -d "$CONFIG_TEMP_DIR/wallpapers" ]; then
    WALLPAPER_DIR="$HOME/Pictures/wallpapers"
    mkdir -p "$WALLPAPER_DIR"
    echo "🖼 Copying wallpapers..."
    cp -rf "$CONFIG_TEMP_DIR/wallpapers/"* "$WALLPAPER_DIR/"
fi

# -----------------------------------------------------------------------------
# Run change-wallpaper.sh to set wallpaper and generate colors
# -----------------------------------------------------------------------------
WALLPAPER=$(find "$HOME/Pictures/wallpapers" -type f | head -n 1)
if [ -n "$WALLPAPER" ] && [ -f "$HOME/.config/scripts/change-wallpaper.sh" ]; then
    echo "🎨 Setting wallpaper and updating colors..."
    bash "$HOME/.config/scripts/change-wallpaper.sh" "$WALLPAPER"
fi

# -----------------------------------------------------------------------------
# Reload Hyprland and bars
# -----------------------------------------------------------------------------
echo "🔄 Reloading Hyprland and bars..."
hyprctl reload 2>/dev/null || true
pkill -USR2 waybar 2>/dev/null || true
pkill -USR2 warbar 2>/dev/null || true

# -----------------------------------------------------------------------------
# Cleanup
# -----------------------------------------------------------------------------
rm -rf "$CONFIG_TEMP_DIR"

echo "✅ Setup complete!"
if [ "$UPDATE_ONLY" = false ]; then
    echo "💡 Log out and log back into Hyprland for first-time setup."
else
    echo "💡 Configs updated successfully without reinstalling packages."
fi
