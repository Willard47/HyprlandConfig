Ultimate Hyprland Laptop Setup

A complete Hyprland environment for Arch Linux minimal, featuring:

Dynamic theming: colors and bars adapt to your wallpaper via Matugen.

Top bar: Warbar and Swaync for workspaces, system stats, music, and weather.

Launchers: Rofi and Wofi with dynamic themes.

Terminal & prompt: Ghostty terminal and Starship prompt.

Editor: Neovim with Lua-based configuration and LSP support.

Utilities: Hyprlock, wlogout, scratchpad, clipboard manager, screenshot utilities.

Automation: Scripts for wallpaper, backups, music notifications, and more.

Features

Autologin & Hyprland startup on TTY1.

Dynamic Rofi menus that match wallpaper colors automatically.

One-command installation for Arch minimal.

Fully modular: tweak bars, scripts, or Neovim independently.

Installation
Prerequisites

Arch Linux minimal installed.

Internet connection.

One-line installer
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/yourusername/HyprlandConfig/main/bootstrap-hyprland-arch-safe.sh)"


This script will:

Install all required packages (official and AUR).

Backup existing ~/.config if present.

Clone this repository into ~/.config.

Make scripts executable.

Install Neovim plugins via Packer.

Configure Starship prompt.

Enable autologin and launch Hyprland automatically.

Set up Warbar, Swaync, Rofi/Wofi, Ghostty, scratchpad, and full dynamic theming.

Usage

Wallpaper & Dynamic Theme:

Change wallpaper using:

~/.config/scripts/change-wallpaper.sh


Colors for bars, menus, and prompts automatically update.

Rofi Menus:

Scripts Menu: SUPER + S

Power Menu: SUPER + P

Scratchpad:

Open quick terminal: SUPER + N

Screenshots:

Full screenshot: Print

Select area: SUPER + Print

Volume & Brightness:

Volume up/down/mute: XF86AudioRaiseVolume, XF86AudioLowerVolume, XF86AudioMute

Brightness up/down: XF86MonBrightnessUp, XF86MonBrightnessDown

Config Structure

~/.config/hypr/ – Hyprland core configs (keybinds, colors, main conf)

~/.config/warbar/ – Top bar configuration

~/.config/swaync/ – Status bar configuration

~/.config/matugen/ – Wallpaper-based dynamic colors

~/.config/scripts/ – Utility scripts for menus, wallpaper, backup, music, etc.

~/.config/rofi/ – Scripts and Power menu themes

~/.config/wofi/ – Application launcher theme

~/.config/starship/ – Terminal prompt config

~/.config/nvim/ – Neovim setup

Optional Customization

Add more wallpapers in ~/Pictures/Wallpapers.

Customize Rofi and Wofi themes.

Extend Neovim with plugins, keymaps, or LSP servers.

Add scripts to ~/.config/scripts/ and update Rofi wrappers.

Notes

The setup is designed for Arch Linux minimal, tested on a laptop.

All menus, bars, and prompts dynamically update to match your wallpaper.

Backups of .config are automatically created before overwriting.
