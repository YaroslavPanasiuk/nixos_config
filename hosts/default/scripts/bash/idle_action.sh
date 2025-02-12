#!/usr/bin/env bash

if playerctl status --all-players 2>/dev/null | grep -q 'Playing'; then 
  echo "Media is currently playing"
  exit 1; 
fi

if [ $# -eq 0 ]; then
  echo "Usage: $0 <option>"
  exit 1
fi

option="$1"

case "$option" in
  "dim")
    brightnessctl -s set 1;
    ;;
  "lock")
    loginctl lock-session
    ;;
  "dpms")
    hyprctl dispatch dpms off
    ;;
  "suspend")
    systemctl suspend
    ;;
  *)
    echo "Invalid option: $option"
    echo "Valid options are: dim, lock, dpms, suspend"
    exit 1
    ;;
esac