{ pkgs }:

pkgs.writeShellScriptBin "swipe_down.sh" '' 
#!/bin/sh
if [[ "$(cat ~/nixos/hosts/default/scripts/DOCK_STATUS.txt)" == "open" ]]; then
    pkill -f -37 nwg-dock-hyprland
    echo "close" > ~/nixos/hosts/default/scripts/DOCK_STATUS.txt
    exit
fi

hyprctl dispatch overview:open
echo "open" > ~/nixos/hosts/default/scripts/HYPRSPACE_STATUS.txt
''
