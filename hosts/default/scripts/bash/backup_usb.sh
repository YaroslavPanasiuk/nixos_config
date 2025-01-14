#!/bin/sh
notify-send -a "USB inserted" -i "/home/yaros/.config/dunst/power.png" -u low "USB" "Udev rule works!!"
cp -rf /home/yaros/backup /run/media/yaros/yaros_usb/yaros_backup