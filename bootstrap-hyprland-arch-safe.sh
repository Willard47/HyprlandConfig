#!/usr/bin/env bash
# bootstrap-hyprland-arch-safe.sh
# Installs Ultimate Hyprland setup on Arch Linux minimal with dependency checks

set -e

REPO_URL="https://github.com/yourusername/HyprlandConfig.git"
CONFIG_DIR="$HOME/.config"
USER_NAME="$USER"
TTY="tty1"

# ---------------- Functions ----------------
check_and_install() {
  local pkg="$1"
  if ! pacman -Qq $pkg &> /dev/null; then
    echo "Installing missing package: $pkg"
    sudo pacman -S --needed --noconfirm $pkg
  fi
}

check_and_install_aur() {
  local pkg="$1"
  if ! pacman -Qq $pkg &> /dev/null; then
    echo "Installing missing AUR package: $pkg"
    yay -S --noconfirm $pkg
  fi
}

# ---------------- Step 1: System Update ----------------
echo "Updating system..."
sudo pacman -Syu --needed --noconfirm

# ---------------- Step 2: Base packages ----------------
echo "Checking base packages..."
for pkg in base-devel git wget curl unzip; do
  check_and_install $pkg
done

# ---------------- Step 3: Install yay if missing ----------------
if ! command -v yay &> /dev/null; then
    echo "Installing yay (AUR helper)..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay
fi

# ---------------- Step 4: Hyprland and core packages ----------------
echo "Checking core Hyprland packages..."
for pkg in hyprland swww waybar swaync starship rofi neovim \
           wl-clipboard clipmenu grim slurp pamixer brightnessctl \
           alsa-utils mpd playerctl thunar; do
  check_and_install $pkg
done

# ---------------- Step 5: AUR packages ----------------
echo "Checking AUR packages..."
for pkg in ghostty nerd-fonts-complete lua-lpeg; do
  check_and_install_aur $pkg
done

# ---------------- Step 6: Backup .config and clone repository ----------------
if [ -d "$CONFIG_DIR" ]; then
    echo "Backing up existing .config..."
    mv "$CONFIG_DIR" "${CONFIG_DIR}.bak_$(date +%Y%m%d_%H%M%S)"
fi
echo "Cloning Hyprland config repository..."
git clone "$REPO_URL" "$CONFIG_DIR"

# ---------------- Step 7: Make scripts executable ----------------
chmod +x "$CONFIG_DIR/scripts/"*.sh

# ---------------- Step 8: Neovim plugin install ----------------
nvim --headless +PackerSync +qa

# ---------------- Step 9: Starship setup ----------------
if ! grep -q "eval \"\$(starship init bash)\"" ~/.bashrc; then
  echo "eval \"\$(starship init bash)\"" >> ~/.bashrc
fi

# ---------------- Step 10: Wallpaper directory ----------------
mkdir -p "$HOME/Pictures/Wallpapers"

# ---------------- Step 11: TTY autologin ----------------
sudo mkdir -p /etc/systemd/system/getty@$TTY.service.d/
sudo tee /etc/systemd/system/getty@$TTY.service.d/override.conf > /dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USER_NAME --noclear %I \$TERM
EOF
sudo systemctl daemon-reexec
sudo systemctl restart getty@$TTY

# ---------------- Step 12: Auto-start Hyprland ----------------
if ! grep -q "exec Hyprland" ~/.bash_profile; then
  tee -a ~/.bash_profile > /dev/null <<EOF
# Start Hyprland automatically on TTY1
if [[ -z \$DISPLAY ]] && [[ \$(tty) == /dev/$TTY ]]; then
    exec Hyprland
fi
EOF
fi

# ---------------- Step 13: Final Message ----------------
echo "Hyprland installation complete with dependency checks!"
echo "Reboot to autologin and launch Hyprland with your full environment."
