#!/bin/sh
ip=$(ip -4 r | awk '{print $9; exit}')
wayvnc $ip 5900 &
notify-send "VNC server" "Listening for connections on $ip:5900"