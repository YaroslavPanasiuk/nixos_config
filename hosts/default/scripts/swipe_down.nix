{ pkgs }:

pkgs.writeShellScriptBin "swipe_down.sh" '' 
#!/bin/sh
if [[ "$(cat ~/nixos/hosts/default/scripts/DOCK_STATUS.txt)" == "open" ]]; then
    pkill -f -37 nwg-dock-hyprland
    echo "close" > ~/nixos/hosts/default/scripts/DOCK_STATUS.txt
    exit
fi
if [[ "$(toggle_hyprpanel_visibility.sh query)" == "false" ]]; then
    toggle_hyprpanel_visibility.sh
fi

''
