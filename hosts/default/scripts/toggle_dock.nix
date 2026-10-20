{ pkgs }:

pkgs.writeShellScriptBin "toggle_dock.sh" '' 
#!/bin/sh
if [[ "$(cat ~/nixos/hosts/default/scripts/DOCK_STATUS.txt)" == "open" ]]; then
    pkill -f -37 nwg-dock-hyprland
    echo "close" > ~/nixos/hosts/default/scripts/DOCK_STATUS.txt
    exit
fi

if ! pidof nwg-dock-hyprland; then
    launch_dock.sh &
fi
pkill -f -36 nwg-dock-hyprland
echo "open" > ~/nixos/hosts/default/scripts/DOCK_STATUS.txt
''
