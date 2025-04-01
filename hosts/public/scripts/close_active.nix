{ pkgs }:

pkgs.writeShellScriptBin "close_active.sh" '' 
#!/usr/bin/env bash
active_workspace=$(hyprctl activeworkspace -j | jq -r '.id')
if hyprctl workspaces -j | jq -e ".[] | select(.id == $active_workspace) | .windows > 0" >/dev/null; then
    hyprctl dispatch killactive
    exit
fi
blank_screen.sh &
''