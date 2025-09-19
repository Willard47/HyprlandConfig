#!/usr/bin/env bash
# Example dynamic workspace colors based on wallpaper
COLOR_BG=$(swww query color)
sed -i "s/color_bg=.*/color_bg=$COLOR_BG/" ~/.config/hypr/colors.conf
