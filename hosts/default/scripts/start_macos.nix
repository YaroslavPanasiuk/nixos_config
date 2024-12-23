{ pkgs }:

pkgs.writeShellScriptBin "start_macos.sh" '' 
#!/bin/sh

~/Documents/stop_windows.sh &

mapfile -t windows < <( hyprctl clients | grep "class: " | awk '{print $2}' )
mapfile -t workspaces < <( hyprctl clients | grep "workspace: " | awk '{print $2}' )

for i in "''${!windows[@]}"; do
    if [[ "''${windows[$i]}" == "qemu" ]]; then
        hyprctl dispatch workspace "''${workspaces[$i]}"
        exit
    fi
done

~/OSX-KVM/OpenCore-Boot.sh &
''
