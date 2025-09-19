#!/usr/bin/env bash
set -e

# -----------------------------------------------------------------------------
# Check for update-only and debug flags
# -----------------------------------------------------------------------------
UPDATE_ONLY=false
DEBUG=false

for arg in "$@"; do
    case $arg in
        --update) UPDATE_ONLY=true ;;
        --debug) DEBUG=true ;;
    esac
done

if [ "$UPDATE_ONLY" = true ]; then
    echo "🔄 Running in UPDATE mode (update configs & scripts only)"
fi
if [ "$DEBUG" = true ]; then
    echo "🐞 Debug mode enabled (will print every file copied)"
fi

# -----------------------------------------------------------------------------
# Install dependencies (fresh install only)
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
# Backup existing .config folder (fresh install only)
# -----------------------------------------------------------------------------
if [ "$UPDATE_ONLY" = false ]; then
    BACKUP_DIR="$HOME/.config.bak_$(date +%Y%m%d%H%M%S)"
    echo "💾 Backing up existing ~/.config to $BACKUP_DIR"
    mv "$HOME/.config" "$BACKUP_DIR" 2>/dev/null || true
fi

mkdir -p "$HOME/.config"

# -----------------------------------------------------------------------------
# Copy configs (excluding scripts first)
# -----------------------------------------------------------------------------
echo "📂 Copying configs..."
shopt -s dotglob
for file in "$CONFIG_TEMP_DIR/.config/"*; do
    if [ "$(basename "$file")" != "scripts" ]; then
        if [ "$DEBUG" = true ]; then
            echo "Copying $file -> ~/.config/"
        fi
        cp -rf "$file" "$HOME/.config/"
    fi
done
shopt -u dotglob

# -----------------------------------------------------------------------------
# Force update scripts folder
# -----------------------------------------------------------------------------
if [ -d "$CONFIG_TEMP_DIR/.config/scripts" ]; then
    echo "🔧 Updating scripts folder..."
    rm -rf "$HOME/.config/scripts"
    if [ "$DEBUG" = true ]; then
        echo "Copying $CONFIG_TEMP_DIR/.config/scripts -> ~/.config/scripts"
    fi
    cp -rf "$CONFIG_TEMP_DIR/.config/scripts" "$HOME/.config/scripts"
fi

# Make scripts executable
find "$HOME/.config/scripts" -type f -exec chmod +x {} \;

# -----------------------------------------------------------------------------
# Copy wallpapers (fresh install only)
# -----------------------------------------------------------------------------
if [ "$UPDATE_ONLY" = false ] && [ -d "$CONFIG_TEMP_DIR/wallpapers" ]; then
    WALLPAPER_DIR="$HOME/Pictures/wallpapers"
    mkdir -p "$WALLPAPER_DIR"
    echo "🖼 Copying wallpapers..."
    for wp in "$CONFIG_TEMP_DIR/wallpapers/"*; do
        if [ "$DEBUG" = true ]; then
            echo "Copying $wp -> $WALLPAPER_DIR/"
        fi
        cp -rf "$wp" "$WALLPAPER_DIR/"
    done
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
