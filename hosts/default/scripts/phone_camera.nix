{ pkgs }:

pkgs.writeShellScriptBin "phone_camera.sh" '' 
#!/usr/bin/env bash

dunstify -a "camera" "Connecting Phone camera..."
pkill -f scrcpy
adb kill-server
adb start-server
adb devices
if [ "$1" = "-c" ]; then 
    scrcpy -d --video-source=camera --camera-facing=back --camera-size=1920x1080 --v4l2-sink=/dev/video0 --audio-source=mic-voice-communication &
    sleep 1
    pw-link -d "scrcpy" "$(pactl get-default-sink)"
    sleep 1
    pw-link -d "scrcpy" "$(pactl get-default-sink)"
    sleep 1
    pw-link -d "scrcpy" "$(pactl get-default-sink)"
    sleep 1
    pw-link -d "scrcpy" "$(pactl get-default-sink)"
    sleep 1
    pw-link "scrcpy" "VirtualMic"
    sleep 1
    pw-link "scrcpy" "VirtualMic"
    sleep 1
    pw-link "scrcpy" "VirtualMic"
    sleep 1
    pw-link "scrcpy" "VirtualMic"
    dunstify -a "camera" "Connected Over cable"
    exit
fi
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
        dunstify -a "camera" "Connected over wifi" 
        scrcpy -d --video-source=camera --camera-facing=back --camera-size=1920x1080 --v4l2-sink=/dev/video0 --audio-source=mic-voice-communication &
        adb disconnect "$ip:5555"
        sleep 1
        pw-link -d "scrcpy" "$(pactl get-default-sink)"
        sleep 1
        pw-link -d "scrcpy" "$(pactl get-default-sink)"
        sleep 1
        pw-link -d "scrcpy" "$(pactl get-default-sink)"
        sleep 1
        pw-link -d "scrcpy" "$(pactl get-default-sink)"
        sleep 1
        pw-link "scrcpy" "VirtualMic"
        sleep 1
        pw-link "scrcpy" "VirtualMic"
        sleep 1
        pw-link "scrcpy" "VirtualMic"
        sleep 1
        pw-link "scrcpy" "VirtualMic"
    else
        dunstify -a "camera" "Unable to connect over wifi"
        scrcpy -d --video-source=camera --camera-facing=back --camera-size=1920x1080 --v4l2-sink=/dev/video0 --audio-source=mic-voice-communication &
        sleep 1
        pw-link -d "scrcpy" "$(pactl get-default-sink)"
        sleep 1
        pw-link -d "scrcpy" "$(pactl get-default-sink)"
        sleep 1
        pw-link -d "scrcpy" "$(pactl get-default-sink)"
        sleep 1
        pw-link -d "scrcpy" "$(pactl get-default-sink)"
        sleep 1
        pw-link "scrcpy" "VirtualMic"
        sleep 1
        pw-link "scrcpy" "VirtualMic"
        sleep 1
        pw-link "scrcpy" "VirtualMic"
        sleep 1
        pw-link "scrcpy" "VirtualMic"
    fi
else 
    dunstify -a "camera" "Unable to connect over wifi"
    scrcpy -d --video-source=camera --camera-facing=back --camera-size=1920x1080 --v4l2-sink=/dev/video0 --audio-source=mic-voice-communication &
    sleep 1
    pw-link -d "scrcpy" "$(pactl get-default-sink)"
    sleep 1
    pw-link -d "scrcpy" "$(pactl get-default-sink)"
    sleep 1
    pw-link -d "scrcpy" "$(pactl get-default-sink)"
    sleep 1
    pw-link -d "scrcpy" "$(pactl get-default-sink)"
    sleep 1
    pw-link "scrcpy" "VirtualMic"
    sleep 1
    pw-link "scrcpy" "VirtualMic"
    sleep 1
    pw-link "scrcpy" "VirtualMic"
    sleep 1
    pw-link "scrcpy" "VirtualMic"
fi
''
