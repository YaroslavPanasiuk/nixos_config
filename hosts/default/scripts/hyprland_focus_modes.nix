{ pkgs }:

pkgs.writeShellScriptBin "hyprland_focus_modes.sh" '' 
#!/usr/bin/env bash

if [ -z "$1" ]; then
    mode=$(echo -e "🎛️ Auto\n🗿 Focus\n💈 Fancy" | rofi -dmenu -config ~/.config/rofi/config-waybar_mode.rasi)
else
    mode="$1"
fi

if [ "$1" == "update" ]; then
    mode="$(cat ~/nixos/hosts/default/scripts/hyprland_focus_mode.txt)"
fi

case "$mode" in
    "💈 Fancy")
        pkill -f waybar_colors_update.sh
        waybar_colors_update.sh set_fancy
        echo "💈 Fancy" > ~/nixos/hosts/default/scripts/hyprland_focus_mode.txt
    ;;
    "🗿 Focus")
        pkill -f waybar_colors_update.sh
        waybar_colors_update.sh set_focus
        echo "🗿 Focus" > ~/nixos/hosts/default/scripts/hyprland_focus_mode.txt
    ;;
    "🎛️ Auto")
        pkill -f waybar_colors_update.sh
        waybar_colors_update.sh update
        waybar_colors_update.sh &
        echo "🎛️ Auto" > ~/nixos/hosts/default/scripts/hyprland_focus_mode.txt
    ;;
esac
''
