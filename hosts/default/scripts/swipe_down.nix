{ pkgs }:

pkgs.writeShellScriptBin "swipe_down.sh" '' 
#!/bin/sh
if pidof nwg-dock-hyprland; then
    pkill -f -37 nwg-dock-hyprland
    exit
fi

cat ~/nixos/hosts/default/scripts/HYPRSPACE_STATUS.txt

if [[ "$(cat ~/nixos/hosts/default/scripts/HYPRSPACE_STATUS.txt)" != "open" ]]; then
    hyprctl dispatch overview:open
    echo "open" > ~/nixos/hosts/default/scripts/HYPRSPACE_STATUS.txt
fi
''
