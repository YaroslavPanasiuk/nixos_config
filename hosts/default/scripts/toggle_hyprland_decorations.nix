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
        hyprctl eval 'hl.config({ animations = { enabled = false }, decoration = { rounding = 0, active_opacity = 1.0, inactive_opacity = 1.0, dim_inactive = false, blur = { enabled = false }, shadow = { enabled = false } }, misc = { disable_hyprland_logo = true, force_default_wallpaper = false } })'
        echo "on" > ~/nixos/hosts/default/scripts/toggle_hyprland_decorations.txt
        notify-send -a "󰤹" "Decorations off"
    ;;
esac


''
