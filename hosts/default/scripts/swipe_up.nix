{ pkgs }:

pkgs.writeShellScriptBin "swipe_up.sh" '' 
#!/bin/sh
if [[ "$(cat ~/nixos/hosts/default/scripts/HYPRSPACE_STATUS.txt)" == "open" ]]; then
    hyprctl dispatch overview:close
    echo "close" > ~/nixos/hosts/default/scripts/HYPRSPACE_STATUS.txt
    exit
fi

if ! pidof nwg-dock-hyprland; then
    launch_dock.sh &
fi
pkill -f -36 nwg-dock-hyprland
''
