#!/bin/sh

if [[ "$(cat ~/nixos/hosts/default/scripts/HYPRSPACE_STATUS.txt)" == "open" ]]; then
    hyprctl dispatch overview:close
    echo "close" > ~/nixos/hosts/default/scripts/HYPRSPACE_STATUS.txt
    exit
fi

if ! pidof waybar; then
    waybar
fi