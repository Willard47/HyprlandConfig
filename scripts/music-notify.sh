#!/usr/bin/env bash
while true; do
  TRACK=$(playerctl metadata title 2>/dev/null)
  ARTIST=$(playerctl metadata artist 2>/dev/null)
  if [ ! -z "$TRACK" ]; then
    notify-send "Now Playing" "$ARTIST - $TRACK" -u low
  fi
  sleep 10
done &
