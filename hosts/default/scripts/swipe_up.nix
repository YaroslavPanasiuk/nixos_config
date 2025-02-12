{ pkgs }:

pkgs.writeShellScriptBin "swipe_up.sh" '' 
#!/bin/sh
if ! pidof nwg-dock-hyprland; then
    launch_dock.sh &
fi
pkill -f -36 nwg-dock-hyprland
echo "open" > ~/nixos/hosts/default/scripts/DOCK_STATUS.txt
''
