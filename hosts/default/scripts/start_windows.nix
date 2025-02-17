{ pkgs }:

pkgs.writeShellScriptBin "start_windows.sh" '' 
#!/bin/sh

# List of opened windows
pkill qemu

mapfile -t windows < <( hyprctl clients | grep "class: " | awk '{print $2}' )
mapfile -t workspaces < <( hyprctl clients | grep "workspace: " | awk '{print $2}' )

for i in "''${!windows[@]}"; do
    if [[ "''${windows[$i]}" == "virt-viewer" ]]; then
        hyprctl dispatch workspace "''${workspaces[$i]}"
        exit
    fi
done

quickemu --vm ~/virtual/windows-10.conf
''
