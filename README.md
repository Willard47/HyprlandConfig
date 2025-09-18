<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Ultimate Hyprland Laptop Setup</title>
<style>
  body { font-family: Arial, sans-serif; line-height: 1.6; padding: 20px; background-color: #f9f9f9; color: #333; }
  h1, h2, h3 { color: #2c3e50; }
  pre { background: #2d2d2d; color: #f8f8f2; padding: 10px; overflow-x: auto; border-radius: 5px; }
  code { font-family: monospace; }
  ul { margin: 10px 0 10px 20px; }
  li { margin-bottom: 5px; }
</style>
</head>
<body>

<h1>Ultimate Hyprland Laptop Setup</h1>

<p>A complete Hyprland environment for Arch Linux minimal, featuring:</p>
<ul>
  <li><strong>Dynamic theming</strong>: colors and bars adapt to your wallpaper via Matugen.</li>
  <li><strong>Top bar</strong>: Warbar and Swaync for workspaces, system stats, music, and weather.</li>
  <li><strong>Launchers</strong>: Rofi and Wofi with dynamic themes.</li>
  <li><strong>Terminal & prompt</strong>: Ghostty terminal and Starship prompt.</li>
  <li><strong>Editor</strong>: Neovim with Lua-based configuration and LSP support.</li>
  <li><strong>Utilities</strong>: Hyprlock, wlogout, scratchpad, clipboard manager, screenshot utilities.</li>
  <li><strong>Automation</strong>: Scripts for wallpaper, backups, music notifications, and more.</li>
</ul>

<h2>Features</h2>
<ul>
  <li>Autologin & Hyprland startup on TTY1.</li>
  <li>Dynamic Rofi menus that match wallpaper colors automatically.</li>
  <li>One-command installation for Arch minimal.</li>
  <li>Fully modular: tweak bars, scripts, or Neovim independently.</li>
</ul>

<h2>Installation</h2>

<h3>Prerequisites</h3>
<ul>
  <li>Arch Linux minimal installed.</li>
  <li>Internet connection.</li>
</ul>

<h3>One-line installer</h3>
<pre><code>/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/yourusername/HyprlandConfig/main/bootstrap-hyprland-arch-safe.sh)"</code></pre>

<p>This script will:</p>
<ul>
  <li>Install all required packages (official and AUR).</li>
  <li>Backup existing <code>~/.config</code> if present.</li>
  <li>Clone this repository into <code>~/.config</code>.</li>
  <li>Make scripts executable.</li>
  <li>Install Neovim plugins via Packer.</li>
  <li>Configure Starship prompt.</li>
  <li>Enable autologin and launch Hyprland automatically.</li>
  <li>Set up Warbar, Swaync, Rofi/Wofi, Ghostty, scratchpad, and full dynamic theming.</li>
</ul>

<h2>Usage</h2>
<ul>
  <li><strong>Wallpaper & Dynamic Theme</strong>:<br>
    <pre><code>~/.config/scripts/change-wallpaper.sh</code></pre>
    Colors for bars, menus, and prompts automatically update.
  </li>
  <li><strong>Rofi Menus</strong>:<br>
    Scripts Menu: <code>SUPER + S</code><br>
    Power Menu: <code>SUPER + P</code>
  </li>
  <li><strong>Scratchpad</strong>:<br>
    Open quick terminal: <code>SUPER + N</code>
  </li>
  <li><strong>Screenshots</strong>:<br>
    Full screenshot: <code>Print</code><br>
    Select area: <code>SUPER + Print</code>
  </li>
  <li><strong>Volume & Brightness</strong>:<br>
    Volume up/down/mute: <code>XF86AudioRaiseVolume</code>, <code>XF86AudioLowerVolume</code>, <code>XF86AudioMute</code><br>
    Brightness up/down: <code>XF86MonBrightnessUp</code>, <code>XF86MonBrightnessDown</code>
  </li>
</ul>

<h2>Config Structure</h2>
<ul>
  <li><code>~/.config/hypr/</code> – Hyprland core configs (keybinds, colors, main conf)</li>
  <li><code>~/.config/warbar/</code> – Top bar configuration</li>
  <li><code>~/.config/swaync/</code> – Status bar configuration</li>
  <li><code>~/.config/matugen/</code> – Wallpaper-based dynamic colors</li>
  <li><code>~/.config/scripts/</code> – Utility scripts for menus, wallpaper, backup, music, etc.</li>
  <li><code>~/.config/rofi/</code> – Scripts and Power menu themes</li>
  <li><code>~/.config/wofi/</code> – Application launcher theme</li>
  <li><code>~/.config/starship/</code> – Terminal prompt config</li>
  <li><code>~/.config/nvim/</code> – Neovim setup</li>
</ul>

<h2>Optional Customization</h2>
<ul>
  <li>Add more wallpapers in <code>~/Pictures/Wallpapers</code>.</li>
  <li>Customize Rofi and Wofi themes.</li>
  <li>Extend Neovim with plugins, keymaps, or LSP servers.</li>
  <li>Add scripts to <code>~/.config/scripts/</code> and update Rofi wrappers.</li>
</ul>

<h2>Notes</h2>
<ul>
  <li>The setup is designed for Arch Linux minimal, tested on a laptop.</li>
  <li>All menus, bars, and prompts dynamically update to match your wallpaper.</li>
  <li>Backups of <code>.config</code> are automatically created before overwriting.</li>
  <li>This was all done with the help of AI.</li>
  <li>Hopefully this works!</li>
</ul>

</body>
</html>
