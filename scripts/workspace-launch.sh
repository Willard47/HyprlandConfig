#!/usr/bin/env bash
WS=$(hyprctl activeworkspace | awk '{print $2}')
case $WS in
  1) ghostty & nvim & ;;
  2) firefox & thunderbird & ;;
  3) spotify & ;;
esac
