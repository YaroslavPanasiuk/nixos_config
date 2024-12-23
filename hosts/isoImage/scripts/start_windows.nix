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

virsh --connect qemu:///system net-start default
virsh --connect qemu:///system start 'RDPWindows'
virt-viewer --connect qemu:///system --full-screen 'RDPWindows'

while pgrep -x "virt-viewer" > /dev/null
do
  echo "check"
  sleep 30
done

echo "virt-viewer closed, shutting down VM..."
~/Documents/stop_windows.sh
''
