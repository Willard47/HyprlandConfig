#!/usr/bin/env bash
set -e

# -----------------------------------------------------------------------------
# Check if running as update-only
# -----------------------------------------------------------------------------
UPDATE_ONLY=false
if [[ "$1" == "--update" ]]; then
    UPDATE_ONLY=true
    echo "🔄 Running in UPDATE mode (will only update configs and scripts)"
fi

# -----------------------------------------------------------------------------
# Install dependencies (only on fresh installs)
# -----------------------------------------------------------------------------
if [ "$UPDATE_ONLY" = false ]; then
    echo "📦 Installing required packages..."
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

# -----------------------------------------------------------------------------
# Backup existing .config folder (optional safety)
# -----------------------------------------------------------------------------
BACKUP_DIR="$HOME/.config.bak_$(date +%Y%m%d%H%M%S)"
echo "💾 Backing up existing ~/.config to $BACKUP_DIR"
mv "$HOME/.config" "$BACKUP_DIR" 2>/dev/null || true
mkdir -p "$HOME/.config"

# -----------------------------------------------------------------------------
# Copy configs to ~/.config
# -----------------------------------------------------------------------------
echo "📂 Copying configs..."
cp -rf "$CONFIG_TEMP_DIR/.config/"* ~/.config/

# Force update scripts folder
if [ -d "$CONFIG_TEMP_DIR/.config/scripts" ]; then
    echo "🔧 Updating scripts folder..."
    rm -rf "$HOME/.config/scripts"
    cp -rf "$CONFIG_TEMP_DIR/.config/scripts" "$HOME/.config/scripts"
fi

# Make scripts executable
find ~/.config/scripts -type f -exec chmod +x {} \;

# -----------------------------------------------------------------------------
# Download wallpapers from repo if fresh install
# -----------------------------------------------------------------------------
if [ "$UPDATE_ONLY" = false ] && [ -d "$CONFIG_TEMP_DIR/wallpapers" ]; then
    WALLPAPER_DIR="$HOME/Pictures/wallpapers"
    mkdir -p "$WALLPAPER_DIR"
    echo "🖼 Copying wallpapers..."
    cp -rf "$CONFIG_TEMP_DIR/wallpapers/"* "$WALLPAPER_DIR/"
fi

# -----------------------------------------------------------------------------
# Set wallpaper & generate colors
# -----------------------------------------------------------------------------
WALLPAPER=$(find "$HOME/Pictures/wallpapers" -type f | head -n 1)
if [ -n "$WALLPAPER" ] && [ -f "$HOME/.config/scripts/change-wallpaper.sh" ]; then
    echo "🎨 Setting wallpaper and updating colors..."
    bash "$HOME/.config/scripts/change-wallpaper.sh" "$WALLPAPER"
fi

# -----------------------------------------------------------------------------
# Reload Hyprland & bars
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
    echo "💡 Configs and scripts updated successfully."
fi
