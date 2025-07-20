{ pkgs }:

pkgs.writeShellScriptBin "phone_camera.sh" '' 
dunstify -a "camera" "Connecting Phone camera..."
adb kill-server
adb start-server
adb devices
if [ "$1" = "-c" ]; then 
    scrcpy -d --video-source=camera --camera-facing=back --camera-size=1920x1080 --v4l2-sink=/dev/video0 --no-audio &
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
        scrcpy -e --video-source=camera --camera-facing=back --camera-size=1920x1080 --v4l2-sink=/dev/video0 --no-audio 
        adb disconnect "$ip:5555"
    else
        dunstify -a "camera" "Unable to connect over wifi"
        scrcpy -d --video-source=camera --camera-facing=back --camera-size=1920x1080 --v4l2-sink=/dev/video0 --no-audio 
    fi
else 
    dunstify -a "camera" "Unable to connect over wifi"
    scrcpy -d --video-source=camera --camera-facing=back --camera-size=1920x1080 --v4l2-sink=/dev/video0 --no-audio 
fi
''
