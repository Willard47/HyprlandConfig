#!/usr/bin/env bash
set -e

echo "🚀 Starting Hyprland full setup..."

# -----------------------------------------------------------------------------
# 📦 Install dependencies (Arch-based)
# -----------------------------------------------------------------------------
sudo pacman -Syu --needed --noconfirm \
    hyprland waybar swaync swww \
    rofi wlogout hyprlock \
    starship neovim \
    ttf-nerd-fonts-symbols \
    curl git unzip wget jq \
    wl-clipboard grim slurp playerctl \
    python-pip

# -----------------------------------------------------------------------------
# 📥 Pull latest configs from GitHub
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
echo "🔧 Setting execute permissions on scripts..."
find ~/.config/scripts -type f -exec chmod +x {} \;

# -----------------------------------------------------------------------------
# 🖼 Download wallpaper(s) from repo & set as background
# -----------------------------------------------------------------------------
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
mkdir -p "$WALLPAPER_DIR"

# Copy wallpaper(s) from repo if they exist
if [ -d "$CONFIG_TEMP_DIR/wallpapers" ]; then
    echo "🖼 Copying wallpapers..."
    cp -rf "$CONFIG_TEMP_DIR/wallpapers/"* "$WALLPAPER_DIR/"
fi

# Pick first wallpaper in directory
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | head -n 1)

if [ -n "$WALLPAPER" ]; then
    echo "🎨 Setting wallpaper and generating colors..."
    swww init || true
    swww img "$WALLPAPER" --transition-type wipe --transition-step 90

    if [ -f "$HOME/.config/scripts/change-wallpaper.sh" ]; then
        bash "$HOME/.config/scripts/change-wallpaper.sh" "$WALLPAPER"
    fi
else
    echo "⚠️ No wallpapers found — skipping wallpaper setup."
fi

# -----------------------------------------------------------------------------
# ♻️ Reload Hyprland & Bar for immediate effect
# -----------------------------------------------------------------------------
echo "🔄 Reloading Hyprland..."
if command -v hyprctl &>/dev/null; then
    hyprctl reload || true
fi

# Restart Waybar or Warbar to apply colors
pkill -USR2 waybar 2>/dev/null || true
pkill -USR2 warbar 2>/dev/null || true

# -----------------------------------------------------------------------------
# 🧹 Cleanup
# -----------------------------------------------------------------------------
rm -rf "$CONFIG_TEMP_DIR"

echo "✅ Setup complete! Log out and log back into Hyprland for best results."
