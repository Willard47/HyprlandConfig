#!/usr/bin/env bash
TIME=$(date +"%H:%M")
DATE=$(date +"%A, %B %d")
BAT=$(upower -i $(upower -e | grep BAT) | grep percentage | awk '{print $2}')
notify-send "Welcome back!" "Time: $TIME\nDate: $DATE\nBattery: $BAT" -u normal
