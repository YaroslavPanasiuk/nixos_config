{ pkgs }:

pkgs.writeShellScriptBin "brightness.sh" '' 
#!/usr/bin/env bash

get_brightness() {
  current=$(brightnessctl g)
  max=$(brightnessctl m)
  echo $((current * 100 / max))
}

function send_notification {
    brightness=$(get_brightness)
    echo $brightness
    if [ $brightness -le 10 ]; then
        image="$HOME/nixos/hosts/default/scripts/resources/brightness1.png"
    elif [ $brightness -le 30 ]; then
        image="$HOME/nixos/hosts/default/scripts/resources/brightness2.png"
    elif [ $brightness -le 50 ]; then
        image="$HOME/nixos/hosts/default/scripts/resources/brightness3.png"
    elif [ $brightness -le 70 ]; then
        image="$HOME/nixos/hosts/default/scripts/resources/brightness4.png"
    elif [ $brightness -le 90 ]; then
        image="$HOME/nixos/hosts/default/scripts/resources/brightness5.png"
    else
        image="$HOME/nixos/hosts/default/scripts/resources/brightness6.png"
    fi
    notify-send -u low -r 1234 -h int:value:$brightness "volume" -a "volume_notification" -i $image

}

case $1 in
    up)
	brightnessctl set $2%+ 
	#send_notification
	;;
    down)
	brightnessctl set $2%-
	if [ $(brightnessctl get) -le 1 ]; then 
		brightnessctl set 1
	fi
	#send_notification
	;;
    
esac
''
