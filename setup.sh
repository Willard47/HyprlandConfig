#!/usr/bin/env bash
set -e

# -----------------------------------------------------------------------------
# Flags
# -----------------------------------------------------------------------------
UPDATE_ONLY=false
DEBUG=false

for arg in "$@"; do
    case "$arg" in
        --update) UPDATE_ONLY=true ;;
        --debug) DEBUG=true ;;
    esac
done

echo "💡 UPDATE_ONLY=$UPDATE_ONLY DEBUG=$DEBUG"

# -----------------------------------------------------------------------------
# Dependencies (fresh install only)
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
# Clone repo
# -----------------------------------------------------------------------------
CONFIG_REPO="https://github.com/Willard47/HyprlandConfig.git"
CONFIG_TEMP_DIR="$HOME/.cache/HyprlandConfig"

echo "📥 Cloning repository..."
rm -rf "$CONFIG_TEMP_DIR"
git clone --depth=1 "$CONFIG_REPO" "$CONFIG_TEMP_DIR"

# Verify .config exists
if [ ! -d "$CONFIG_TEMP_DIR/.config" ]; then
    echo "❌ ERROR: .config folder not found in repo!"
    exit 1
fi

mkdir -p "$HOME/.config"

# -----------------------------------------------------------------------------
# Backup existing configs (fresh install only)
# -----------------------------------------------------------------------------
if [ "$UPDATE_ONLY" = false ]; then
    BACKUP_DIR="$HOME/.config.bak_$(date +%Y%m%d%H%M%S)"
    echo "💾 Backing up existing ~/.config to $BACKUP_DIR"
    mv "$HOME/.config" "$BACKUP_DIR" 2>/dev/null || true
    mkdir -p "$HOME/.config"
fi

# -----------------------------------------------------------------------------
# Copy configs (excluding scripts first)
# -----------------------------------------------------------------------------
echo "📂 Copying configs..."
shopt -s dotglob
for file in "$CONFIG_TEMP_DIR/.config/"*; do
    [ "$(basename "$file")" != "scripts" ] || continue
    [ "$DEBUG" = true ] && echo "Copying $file -> ~/.config/"
    cp -rf "$file" "$HOME/.config/"
done
shopt -u dotglob

# -----------------------------------------------------------------------------
# Copy scripts folder
# -----------------------------------------------------------------------------
if [ -d "$CONFIG_TEMP_DIR/.config/scripts" ]; then
    echo "🔧 Copying scripts folder..."
    rm -rf "$HOME/.config/scripts"
    [ "$DEBUG" = true ] && echo "Copying $CONFIG_TEMP_DIR/.config/scripts -> ~/.config/scripts"
    cp -rf "$CONFIG_TEMP_DIR/.config/scripts" "$HOME/.config/scripts"
    find "$HOME/.config/scripts" -type f -exec chmod +x {} \;
fi

# -----------------------------------------------------------------------------
# Copy wallpapers (fresh install only)
# -----------------------------------------------------------------------------
if [ "$UPDATE_ONLY" = false ] && [ -d "$CONFIG_TEMP_DIR/wallpapers" ]; then
    WALLPAPER_DIR="$HOME/Pictures/wallpapers"
    mkdir -p "$WALLPAPER_DIR"
    echo "🖼 Copying wallpapers..."
    for wp in "$CONFIG_TEMP_DIR/wallpapers/"*; do
        [ "$DEBUG" = true ] && echo "Copying $wp -> $WALLPAPER_DIR/"
        cp -rf "$wp" "$WALLPAPER_DIR/"
    done
fi

# -----------------------------------------------------------------------------
# Set wallpaper & regenerate colors
# -----------------------------------------------------------------------------
if [ -f "$HOME/.config/scripts/change-wallpaper.sh" ]; then
    WALLPAPER=$(find "$HOME/Pictures/wallpapers" -type f | head -n 1)
    if [ -n "$WALLPAPER" ]; then
        echo "🎨 Setting wallpaper and generating colors..."
        bash "$HOME/.config/scripts/change-wallpaper.sh" "$WALLPAPER"
    fi
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
