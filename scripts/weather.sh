#!/usr/bin/env bash
while true; do
  WEATHER=$(curl -s wttr.in/?format="%c+%t")
  hyprctl keyword add weather "$WEATHER"
  sleep 600
done &
