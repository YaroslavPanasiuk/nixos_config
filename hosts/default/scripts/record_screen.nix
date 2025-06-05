{ pkgs }:

pkgs.writeShellScriptBin "record_screen.sh" '' 
#!/bin/sh

if pidof -qx "wf-recorder"; then
 	pkill -SIGINT wf-recorder 
    notify-send -t 5000 -i ~/nixos/hosts/default/scripts/resources/harddisk.png "Screen recorder" "Writing file to ~/Videos/recordings/$(date +'%d.%m.%Y_%H:%M:%S').mp4"
    exit
fi

case "$1" in
    "ao")
        notify-send -t 2000 -i ~/nixos/hosts/default/scripts/resources/rec-button.png "Screen recorder" "Started recording with audio output"
        wf-recorder --audio="$(pactl get-default-sink).monitor" -f "Videos/recordings/$(date +'%d.%m.%Y_%H:%M:%S').mp4"
        ;;
    "ai")
        notify-send -t 2000 -i ~/nixos/hosts/default/scripts/resources/rec-button.png "Screen recorder" "Started recording with audio input"
        wf-recorder --audio="easyeffects_source" -f "Videos/recordings/$(date +'%d.%m.%Y_%H:%M:%S').mp4"
        ;;
    "ac")
        pactl unload-module $(pactl list short modules | grep combined_sink | awk '{print $1}')
        sink="$(pactl get-default-sink)"
        source="easyeffects_source"
        pactl load-module module-null-sink sink_name=combined_sink
        pw-link $source combined_sink
        pw-link $sink combined_sink
        notify-send -t 2000 -i ~/nixos/hosts/default/scripts/resources/rec-button.png "Screen recorder" "Started recording with combined audio input"
        wf-recorder --audio="combined_sink.monitor" -f "Videos/recordings/$(date +'%d.%m.%Y_%H:%M:%S').mp4"
        pactl unload-module $(pactl list short modules | grep combined_sink | awk '{print $1}')
        ;;
    *)
        notify-send -t 2000 -i ~/nixos/hosts/default/scripts/resources/rec-button.png "Screen recorder" "Started recording with no audio"
        wf-recorder -f "Videos/recordings/$(date +'%d.%m.%Y_%H:%M:%S').mp4"
        ;;
esac
''
