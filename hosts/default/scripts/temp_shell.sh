#!/usr/bin/env bash

layout=$(hyprctl devices -j | jq '.keyboards.[] | select(.main == true).active_keymap' | awk '{print $NF}')

if [ "$layout" = '"Ukrainian"' ]; then 
    wl-paste | tesseract -l ukr stdin - | wl-copy
    exit
fi
if [ "$layout" = '(US)"' ]; then 
    wl-paste | tesseract -l eng stdin - | wl-copy
    exit
fi
