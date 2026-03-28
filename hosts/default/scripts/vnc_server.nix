{ pkgs }:

pkgs.writeShellScriptBin "vnc_server.sh" '' 
#!/usr/bin/env bash

connect_avnc() {
    adb shell input keyevent KEYCODE_WAKEUP
    sleep 1
    adb shell input swipe 500 1500 500 500
    sleep 1
    adb shell input text 1246
    sleep 1
    adb shell input keyevent KEYCODE_ENTER
    sleep 1
    adb shell monkey -p com.gaurav.avnc -c android.intent.category.LAUNCHER 1
    sleep 2
    adb shell input tap 360 300
    sleep 1
    adb shell input tap 360 1150
}

if [[ -n "$(pgrep -a wayvnc)" ]]; then 
    pkill wayvnc
    adb shell input keyevent KEYCODE_SLEEP
    hyprctl output remove phone_monitor_wifi
    hyprctl output remove phone_monitor_cable
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
    hyprctl output create headless phone_monitor_wifi
    wayvnc --output=phone_monitor_wifi $ip 5900 &
    notify-send "VNC server" "Listening for connections on $ip:5900"
    exit
fi


if [[ "$1" == "two_monitors" ]]; then
    ip=$(ip -4 r | awk '{print $9; exit}')
    hyprctl output create headless phone_monitor_cable
    hyprctl output create headless phone_monitor_wifi
    adb reverse tcp:5900 tcp:5900
    wayvnc --output=phone_monitor_cable 127.0.0.1 5900 -S=$XDG_RUNTIME_DIR/wayvncctl-1 &
    wayvnc --output=phone_monitor_wifi 192.168.31.71 5901 -S=$XDG_RUNTIME_DIR/wayvncctl-2 &
    notify-send "VNC server" "Listening for connections on $ip:5900 and $ip:5901"
    echo $(connect_avnc)
    exit
fi

if [[ "$1" == "second_monitor_cable" ]]; then
    ip=127.0.0.1
    hyprctl output create headless phone_monitor_cable
    adb reverse tcp:5900 tcp:5900
    wayvnc --output=phone_monitor_cable $ip 5900 &
    notify-send "VNC server" "Listening for connections on $ip:5900"
    echo $(connect_avnc)
    exit
fi

''
