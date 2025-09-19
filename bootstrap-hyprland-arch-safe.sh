#!/usr/bin/env bash
set -e

echo "🔧 Starting Hyprland full setup for Arch minimal..."

# --- Step 1: Install prerequisites
echo "📦 Installing base-devel, git, and essential packages..."
sudo pacman -Syu --needed --noconfirm base-devel git curl wget jq

# --- Step 2: Install official packages
echo "📦 Installing core packages..."
sudo pacman -S --noconfirm hyprland waybar swaync rofi wofi swww \
    starship neovim ghostty playerctl brightnessctl grim slurp wl-clipboard \
    hyprlock wlogout pamixer pavucontrol ttf-nerd-fonts-symbols-mono

# --- Step 3: Backup and clone config
if [ -d "$HOME/.config" ]; then
    echo "📂 Backing up existing ~/.config to ~/.config.bak"
    mv ~/.config ~/.config.bak
fi

echo "📥 Cloning HyprlandConfig repo..."
git clone https://github.com/Willard47/HyprlandConfig.git ~/.config

# --- Step 4: Ensure colors.conf exists
COLORS_FILE="$HOME/.config/hypr/colors.conf"
if [ ! -f "$COLORS_FILE" ]; then
    echo "🎨 Creating fallback colors.conf..."
    mkdir -p "$(dirname "$COLORS_FILE")"
    cat > "$COLORS_FILE" <<EOF
# Fallback colors until Matugen generates them
\$accent = rgb(89b4fa)
\$background = rgb(1e1e2e)
\$foreground = rgb(cdd6f4)
EOF
fi

# --- Step 5: Generate first wallpaper & theme
echo "🖼 Setting initial wallpaper & generating colors..."
if [ -x "$HOME/.config/scripts/change-wallpaper.sh" ]; then
    "$HOME/.config/scripts/change-wallpaper.sh" || echo "⚠️ Wallpaper script failed, skipping"
else
    echo "⚠️ No wallpaper script found, skipping wallpaper setup"
fi

# --- Step 6: Ensure keybind for closing windows
KEYBINDS_FILE="$HOME/.config/hypr/keybinds.conf"
if ! grep -q "killactive" "$KEYBINDS_FILE"; then
    echo "🖱 Adding SUPER+Q close window keybind..."
    echo "bind=SUPER,Q,killactive" >> "$KEYBINDS_FILE"
fi

# --- Step 7: Ensure wlogout layout
echo "🔧 Creating default wlogout layout..."
mkdir -p ~/.config/wlogout
cat > ~/.config/wlogout/layout <<'EOF'
[
  { "label": "logout", "action": "hyprctl dispatch exit", "text": "Logout" },
  { "label": "shutdown", "action": "systemctl poweroff", "text": "Shutdown" },
  { "label": "reboot", "action": "systemctl reboot", "text": "Reboot" },
  { "label": "suspend", "action": "systemctl suspend", "text": "Suspend" }
]
EOF

# --- Step 8: Ensure hyprlock.conf exists
echo "🔒 Creating default hyprlock config..."
mkdir -p ~/.config/hypr
cat > ~/.config/hypr/hyprlock.conf <<'EOF'
# Minimal Hyprlock config
background {
    color = rgba(0,0,0,0.6)
}
label {
    text = <user>
    font_size = 28
    color = rgba(255,255,255,1.0)
    position = 0, 50
}
EOF

# --- Step 9: Ensure Neovim init.lua exists
NVIM_INIT="$HOME/.config/nvim/init.lua"
if [ ! -f "$NVIM_INIT" ]; then
    echo "📝 Creating minimal Neovim init.lua..."
    mkdir -p ~/.config/nvim
    cat > "$NVIM_INIT" <<'EOF'
require("plugins")
require("keymaps")
require("lsp")
EOF
fi

# --- Step 10: Install Neovim plugins
if command -v nvim &> /dev/null; then
    echo "📦 Installing Neovim plugins via Packer..."
    nvim --headless +PackerSync +qall || echo "⚠️ Neovim plugin sync failed, check config"
fi

# --- Step 11: Make scripts executable
echo "⚙️ Making all scripts executable..."
find ~/.config/scripts -type f -iname "*.sh" -exec chmod +x {} \;

echo "✅ Setup complete! Reboot or log out to start Hyprland."
