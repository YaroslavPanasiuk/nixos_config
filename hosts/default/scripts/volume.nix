{ pkgs, }:

pkgs.writeShellScriptBin "volume.sh" ''
#!/usr/bin/env bash

function get_volume {
    echo $(wpctl get-volume @DEFAULT_AUDIO_SINK@) | awk -v N=2 '{print $N}'
}

function is_mute {
    muted=$(echo $(wpctl get-volume @DEFAULT_AUDIO_SINK@) | awk '{ match($0, /\[[^]]+\]/); if (RSTART > 0) print substr($0, RSTART+1, RLENGTH-2) }')
	if [ "$muted" = "MUTED" ]; then
  		return 0
  	else
  		return 1
  	fi
}

function send_notification () {
    volume=$(awk -v n="$(get_volume)" 'BEGIN {print n * 100}')
    
    if [ $volume -le 0 ]; then
        image=$HOME/nixos/hosts/default/scripts/resources/volume_"$1"1.png
    elif [ $volume -le 20 ]; then
        image=$HOME/nixos/hosts/default/scripts/resources/volume_"$1"2.png
    elif [ $volume -le 40 ]; then
        image=$HOME/nixos/hosts/default/scripts/resources/volume_"$1"3.png
    elif [ $volume -le 60 ]; then
        image=$HOME/nixos/hosts/default/scripts/resources/volume_"$1"4.png
    elif [ $volume -le 80 ]; then
        image=$HOME/nixos/hosts/default/scripts/resources/volume_"$1"5.png
    else
        image=$HOME/nixos/hosts/default/scripts/resources/volume_"$1"6.png
    fi

    notify-send -u low -r 4321 -h int:value:$volume "volume" -a "volume_notification" -i $image

}    

case $1 in
    up)
	# Set the volume on (if it was muted)
	wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
	# Up the volume (+ 5%)
	wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+ 
    send_notification up
	;;
    down)
	# Set the volume on (if it was muted)
	wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
	# Up the volume (+ 5%)
	wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-
    send_notification down
	;;
    mute)
    	# Toggle mute
	wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
	if is_mute ; then
		notify-send -u low -r 4321 "muted" -a "volume_notification" -i "$HOME/nixos/hosts/default/scripts/resources/volume_mute.png"
	else
	    send_notification up
	fi
	;;
esac
''