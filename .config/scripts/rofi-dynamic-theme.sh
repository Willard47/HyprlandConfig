#!/usr/bin/env bash

# Ensure cache directory exists
CACHE_DIR="$HOME/.cache"
mkdir -p "$CACHE_DIR"

# Read latest colors from hypr/colors.conf
COLOR_BG=$(grep "color_bg" ~/.config/hypr/colors.conf | cut -d'=' -f2 | tr -d ' ')
COLOR_FG=$(grep "color_fg" ~/.config/hypr/colors.conf | cut -d'=' -f2 | tr -d ' ')
COLOR_ACC=$(grep "color_accent" ~/.config/hypr/colors.conf | cut -d'=' -f2 | tr -d ' ')

# Temporary theme file
THEME_FILE="$CACHE_DIR/rofi-theme.rasi"
cat > "$THEME_FILE" <<EOF
configuration {
    background: "$COLOR_BG";
    foreground: "$COLOR_FG";
    accent: "$COLOR_ACC";
    font: "FiraCode Nerd Font 10";
    show-icons: true;
}
EOF

echo "$THEME_FILE"
