{ pkgs }:

pkgs.writeShellScriptBin "connect_phone.sh" '' 
#!/usr/bin/env bash

dunstify -a "scrcpy" "connecting device..."
adb kill-server
adb start-server
adb devices

hotspot=$(adb shell ip -f inet addr show wlan1 | grep "inet " | awk '{print $2}' | cut -d/ -f1)
ip=$(adb shell ip -f inet addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1)
if [ -z "$ip" ]; then
    ip=$hotspot
fi
if [ -n "$ip" ]; then
    adb tcpip 5555
    sleep 2
    connected=$(adb connect "$ip:5555" | awk '{print $1}')
    echo "$connected"
    if [ "$connected" = "connected" ]; then 
        dunstify -a "scrcpy" "Connected over wifi" 
        scrcpy -e --video-codec=h265 -m1920 --max-fps=60 --no-audio -K
        adb disconnect "$ip:5555"
    else
        dunstify -a "scrcpy" "Unable to connect over wifi"
        scrcpy -d --video-codec=h265 -m1920 --max-fps=60 --no-audio -K
    fi
else 
    dunstify -a "scrcpy" "Unable to connect over wifi"
    scrcpy -d --video-codec=h265 -m1920 --max-fps=60 --no-audio -K
fi
''
