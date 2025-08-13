{ pkgs }:

pkgs.writeShellScriptBin "hyprland_focus_modes.sh" '' 
#!/usr/bin/env bash

mode=$(echo -e "💈 Fancy\n🗿 Focus\n🎛️ Auto" | rofi -dmenu -config ~/.config/rofi/config-waybar_mode.rasi)

case "$mode" in
    "💈 Fancy")
        pkill -f waybar_colors_update.sh
        waybar_colors_update.sh set_fancy
    ;;
    "🗿 Focus")
        pkill -f waybar_colors_update.sh
        waybar_colors_update.sh set_focus
    ;;
    "🎛️ Auto")
        pkill -f waybar_colors_update.sh
        waybar_colors_update.sh update
        waybar_colors_update.sh &
    ;;
esac
''
