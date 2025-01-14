{ pkgs }:

pkgs.writeShellScriptBin "battery_listener.sh" '' 
#!/bin/sh

HIGH_THRESHOLD=80
LOW_THRESHOLD=20
CRITICAL_LOW_THRESHOLD=10

BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)
BATTERY_STATUS=$(cat /sys/class/power_supply/BAT0/status)

if [ "$BATTERY_STATUS" == "Charging" ] && [ "$BATTERY_LEVEL" -ge "$HIGH_THRESHOLD" ]; then
    notify-send -a "High battery" -i "/home/yaros/.config/dunst/power.png" -u low "charge" "Stop charging to extend battery life (''${BATTERY_LEVEL}% charged)"
    echo "high" >> /home/yaros/.config/systemd/user/temp.txt
    exit
fi

if [ "$BATTERY_STATUS" == "Discharging" ] && [ "$BATTERY_LEVEL" -le "$CRITICAL_LOW_THRESHOLD" ]; then
    notify-send -a "Low battery" -i "/home/yaros/.config/dunst/low.png" -u critical "charge" "CHARGE NOW (''${BATTERY_LEVEL}% left)"
    echo "low" >> /home/yaros/.config/systemd/user/temp.txt
    exit
fi

if [ "$BATTERY_STATUS" == "Discharging" ] && [ "$BATTERY_LEVEL" -le "$LOW_THRESHOLD" ]; then
    notify-send -a "Low battery" -i "/home/yaros/.config/dunst/battery-status.png" "charge" "Low battery (''${BATTERY_LEVEL}% left)"
    echo "very_low" >> /home/yaros/.config/systemd/user/temp.txt
fi
''
