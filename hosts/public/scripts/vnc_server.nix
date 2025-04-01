{ pkgs }:

pkgs.writeShellScriptBin "vnc_server.sh" '' 
#!/usr/bin/env bash

if [[ -n "$(pgrep -a wayvnc)" ]]; then 
    pkill wayvnc
    hyprctl output remove phone_monitor
    notify-send "VNC server" "VNC connection closed"
    exit
fi

if [[ "$1" == "remote_control" ]]; then
    ip=$(ip -4 r | awk '{print $9; exit}')
    wayvnc $ip 5900 &
    notify-send "VNC server" "Listening for connections on $ip:5900"
    exit
fi

if [[ "$1" == "second_monitor" ]]; then
    ip=$(ip -4 r | awk '{print $9; exit}')
    hyprctl output create headless phone_monitor
    wayvnc --output=phone_monitor $ip 5900 &
    notify-send "VNC server" "Listening for connections on $ip:5900"
    exit
fi

''
