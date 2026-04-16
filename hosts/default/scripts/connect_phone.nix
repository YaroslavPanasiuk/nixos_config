{ pkgs }:

pkgs.writeShellScriptBin "connect_phone.sh" '' 
#!/usr/bin/env bash

dunstify -a "scrcpy" "connecting device..."
adb start-server
adb disconnect
serial_num=$(select_adb_device.sh)
if [ "$1" = "-c" ]; then 
    scrcpy -s $serial_num --video-codec=h265 -m1920 --max-fps=60 --no-audio -K --render-driver=opengles2 &
    dunstify -a "camera" "Connected Over cable"
    exit
fi
hotspot=$(adb -s $serial_num shell ip -f inet addr show wlan1 | grep "inet " | awk '{print $2}' | cut -d/ -f1)
ip=$(adb -s $serial_num shell ip -f inet addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1)
if [ -z "$ip" ]; then
    ip=$hotspot
fi
if [ -n "$ip" ]; then
    adb -s $serial_num tcpip 5555
    sleep 2
    connected=$(adb -s $serial_num connect "$ip:5555" | awk '{print $1}')
    echo "$connected"
    if [ "$connected" = "connected" ]; then 
        dunstify -a "scrcpy" "Connected over wifi" 
        scrcpy -s $serial_num --video-codec=h265 -m1920 --max-fps=60 --no-audio -K --render-driver=opengles2
        adb disconnect "$ip:5555"
    else
        dunstify -a "scrcpy" "Unable to connect over wifi"
        scrcpy -s $serial_num --video-codec=h265 -m1920 --max-fps=60 --no-audio -K --render-driver=opengles2
    fi
else 
    dunstify -a "scrcpy" "Unable to connect over wifi"
    scrcpy -s $serial_num --video-codec=h265 -m1920 --max-fps=60 --no-audio -K --render-driver=opengles2
fi
''
