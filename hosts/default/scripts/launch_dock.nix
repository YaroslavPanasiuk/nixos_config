{ pkgs }:

pkgs.writeShellScriptBin "launch_dock.sh" '' 
#!/bin/sh
nwg-dock-hyprland -x -r -mb 5 -ml 10 -mr 10 -mt 5 -c "rofi -show drun" -ico ~/nixos/hosts/default/home-manager/extra_resources/apps.png

''

