{ pkgs }:

pkgs.writeShellScriptBin "phone_camera.sh" '' 
dunstify -a "camera" "Connecting Phone camera..."
adb start-server
adb disconnect
serial_num=$(select_adb_device.sh)
if [ "$1" = "-c" ]; then 
    scrcpy -s $serial_num --video-source=camera --camera-facing=back --camera-size=1920x1080 --v4l2-sink=/dev/video0 --no-audio &
    dunstify -a "camera" "Connected Over cable"
    exit
fi
hotspot=$(adb -s $serial_num shell ip -f inet addr show wlan1 | grep "inet " | awk '{print $2}' | cut -d/ -f1)
ip=$(adb -s $serial_num shell ip -f inet addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1)
if [ -z "$ip" ]; then
    ip=$hotspot
fi
if [ -n "$ip" ]; then
    ad -s $serial_numb tcpip 5555
    sleep 2
    connected=$(adb -s $serial_num connect "$ip:5555" | awk '{print $1}')
    echo "$connected"
    if [ "$connected" = "connected" ]; then 
        dunstify -a "camera" "Connected over wifi" 
        scrcpy -s $serial_num --video-source=camera --camera-facing=back --camera-size=1920x1080 --v4l2-sink=/dev/video0 --no-audio --render-driver=opengles2
        adb -s $serial_num disconnect "$ip:5555"
    else
        dunstify -a "camera" "Unable to connect over wifi"
        scrcpy -s $serial_num --video-source=camera --camera-facing=back --camera-size=1920x1080 --v4l2-sink=/dev/video0 --no-audio --render-driver=opengles2
    fi
else 
    dunstify -a "camera" "Unable to connect over wifi"
    scrcpy -s $serial_num --video-source=camera --camera-facing=back --camera-size=1920x1080 --v4l2-sink=/dev/video0 --no-audio --render-driver=opengles2
fi
''
