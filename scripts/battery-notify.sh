#!/usr/bin/env bash
while true; do
  CAP=$(upower -i $(upower -e | grep BAT) | grep percentage | awk '{print $2}' | tr -d '%')
  if [ "$CAP" -lt 20 ]; then
    notify-send "Battery Low" "$CAP% remaining" -u critical
  fi
  sleep 300
done &
