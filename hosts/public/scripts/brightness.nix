{ pkgs }:

pkgs.writeShellScriptBin "brightness.sh" '' 
#!/bin/sh


function send_notification {
	echo "changing brightness"
}

case $1 in
    up)
	brightnessctl set $2%+ 
	send_notification
	;;
    down)
	brightnessctl set $2%-
	if [ $(brightnessctl get) -le 1 ]; then 
		brightnessctl set 1
	fi
	send_notification
	;;
    
esac
''
