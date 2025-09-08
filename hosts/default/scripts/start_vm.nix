{ pkgs }:

pkgs.writeShellScriptBin "start_vm.sh" '' 
#!/usr/bin/env bash

vm_is_running=$(hyprctl clients | grep "QEMU ($1")

if [[ -n $vm_is_running ]]; then
    address=$(hyprctl clients | grep "QEMU ($1" | grep Window | awk '{print $2}')
    hyprctl dispatch killwindow "address:0x$address"
    exit
fi

if [[ $2 == "single" ]]; then
    hyprctl clients -j | jq -r '.[] | select(.class == ".qemu-system-x86_64-wrapped") | .address' | while read addr; do
        hyprctl dispatch killwindow "address:$addr"
    done
fi

case "$1" in
    "macos")
        quickemu --vm ~/virtual/macos-big-sur.conf --width 1920 --height 1080 &
        ;;
    "windows")
        quickemu --vm ~/virtual/windows-10.conf --display spice --fullscreen &
        ;;
    *)
        notify-send "QEMU" "No such device: $1"
        ;;
esac
''
