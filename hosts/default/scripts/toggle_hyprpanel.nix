{ pkgs }:

pkgs.writeShellScriptBin "toggle_hyprpanel.sh" '' 
#!/bin/sh

if ! pidof -qx "hyprpanel"; then
    pkill dunst
 	hyprpanel &
    sleep 5
    hyprpanel useTheme .cache/wal/hyprbar.json
else 
    pkill hyprpanel
fi

''
