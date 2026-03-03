{ pkgs }:

pkgs.writeShellScriptBin "toggle_hyprland_decorations.sh" '' 
#!/usr/bin/env bash

if [ -z "$1" ]; then
    mode="$(cat ~/nixos/hosts/default/scripts/toggle_hyprland_decorations.txt)"
else
    mode="$1"
fi

case "$mode" in
    "on")
        hyprctl reload
        hyprland_focus_modes.sh "🎛️ Auto"
        echo "off" > ~/nixos/hosts/default/scripts/toggle_hyprland_decorations.txt
        notify-send -a "󰘇" "Decorations on"
    ;;
    "off")
        hyprland_focus_modes.sh "🗿 Focus"
        hyprctl keyword animations:enabled 0
        hyprctl keyword decoration:rounding 0
        hyprctl keyword decoration:active_opacity 1.0
        hyprctl keyword decoration:inactive_opacity 1.0
        hyprctl keyword decoration:dim_inactive 0
        hyprctl keyword decoration:blur:enabled 0
        hyprctl keyword decoration:shadow:enabled 0
        hyprctl keyword misc:disable_hyprland_logo 1
        hyprctl keyword misc:force_default_wallpaper 0
        echo "on" > ~/nixos/hosts/default/scripts/toggle_hyprland_decorations.txt
        notify-send -a "󰤹" "Decorations off"
    ;;
esac


''
