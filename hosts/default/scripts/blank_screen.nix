{ pkgs }:

pkgs.writeShellScriptBin "blank_screen.sh" '' 
#!/usr/bin/env bash
hyprctl dispatch dpms off
libinput debug-events | while read -r line; do
    if [[ $line == *"event"* ]]; then
        hyprctl dispatch dpms on
        exit
    fi
done
''