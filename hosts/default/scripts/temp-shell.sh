#!/bin/sh

if pidof waybar; then
    pkill waybar
    exit
fi

cat ~/nixos/hosts/default/scripts/HYPRSPACE_STATUS.txt

if [[ "$(cat ~/nixos/hosts/default/scripts/HYPRSPACE_STATUS.txt)" != "open" ]]; then
    hyprctl dispatch overview:open
    echo "open" > ~/nixos/hosts/default/scripts/HYPRSPACE_STATUS.txt
fi