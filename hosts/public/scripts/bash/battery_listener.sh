#!/bin/sh

HIGH_THRESHOLD=80
LOW_THRESHOLD=20
CRITICAL_LOW_THRESHOLD=10

BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)
BATTERY_STATUS=$(cat /sys/class/power_supply/BAT0/status)

filename=$HOME/nixos/hosts/default/scripts/bash/battery_status.txt
last_message=$(<$filename)
echo $last_message


if [ "$BATTERY_STATUS" == "Charging" ] && [ "$BATTERY_LEVEL" -ge "$HIGH_THRESHOLD" ] && [ "$last_message" != "high" ]; then
    notify-send -a "High battery" -i "$HOME/.config/dunst/power.png" -u low "charge" "Stop charging to extend battery life (${BATTERY_LEVEL}% charged)"
    echo "high" > $filename
    exit
fi

if [ "$BATTERY_STATUS" == "Discharging" ] && [ "$BATTERY_LEVEL" -le "$CRITICAL_LOW_THRESHOLD" ] && [ "$last_message" != "critical_low" ]; then
    notify-send -a "Low battery" -i "$HOME/.config/dunst/low.png" -u critical "charge" "CHARGE NOW (${BATTERY_LEVEL}% left)"
    echo "critical_low" > $filename
    exit
fi

if [ "$BATTERY_STATUS" == "Discharging" ] && [ "$BATTERY_LEVEL" -le "$LOW_THRESHOLD" ] && [ "$last_message" != "low" ]; then
    notify-send -a "Low battery" -i "$HOME/.config/dunst/battery-status.png" "charge" "Low battery (${BATTERY_LEVEL}% left)"
    echo "low" > $filename
    exit
fi

