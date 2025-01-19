{ pkgs, }:

pkgs.writeShellScriptBin "volume.sh" ''
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

function send_notification {
    volume=`get_volume`
}

    

case $1 in
    up)
	# Set the volume on (if it was muted)
	wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
	# Up the volume (+ 5%)
	wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+ 
	send_notification
	;;
    down)
	# Set the volume on (if it was muted)
	wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
	# Up the volume (+ 5%)
	wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-
	send_notification
	;;
    mute)
    	# Toggle mute
	wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
	if is_mute ; then
		echo "is mute"
	else
	    send_notification
	fi
	;;
esac

''