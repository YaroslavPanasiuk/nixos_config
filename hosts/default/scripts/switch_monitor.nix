{ pkgs }:

pkgs.writeShellScriptBin "switch_monitor.sh" '' 
#!/usr/bin/env bash

monitor=$(( $(hyprctl activeworkspace -j | jq '.id') < 11 ? 1 : 2 ))
prefix=$(( $monitor == 1 ? 1 : 0 ))
command=$([ "$2" = "view" ] && echo "workspace" || echo "movetoworkspacesilent")
hyprctl dispatch $command $prefix$1
''
