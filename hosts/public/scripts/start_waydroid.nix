{ pkgs }:

pkgs.writeShellScriptBin "start_waydroid.sh" '' 
#!/usr/bin/env bash

waydroid_is_running=$(hyprctl clients | grep "class: Waydroid")

if [[ -n $waydroid_is_running ]]; then
    waydroid session stop
    systemctl stop waydroid-container
    pkill Waydroid
    exit
fi

dunstify -a "waydroid" "Starting adnroid device..."
systemctl start waydroid-container
waydroid session start &
waydroid show-full-ui
''
