#!/usr/bin/env bash

if [[ "$(cat ~/nixos/hosts/default/scripts/ACER_MONITOR_TRANSFORM.txt)" == "Horizontal" ]]; then
    hyprctl eval 'hl.monitor({ output = "desc:Acer Technologies B246HL LYDEE0258500", mode = "1920x1080@60", disabled = true })'
    echo "Vertical" > ~/nixos/hosts/default/scripts/ACER_MONITOR_TRANSFORM.txt
    hyprctl eval 'hl.monitor({ output = "desc:Acer Technologies B246HL LYDEE0258500", mode = "1920x1080@60", position = "1920x-850", scale = 1, transform = 1, disabled = false })'
    exit
fi

hyprctl eval 'hl.monitor({ output = "desc:Acer Technologies B246HL LYDEE0258500", disabled = true })'
hyprctl reload
echo "Horizontal" > ~/nixos/hosts/default/scripts/ACER_MONITOR_TRANSFORM.txt