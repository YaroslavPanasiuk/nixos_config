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
        wf-recorder --audio="alsa_output.pci-0000_00_1f.3.analog-stereo.monitor" -f "Videos/recordings/$(date +'%d.%m.%Y_%H:%M:%S').mp4"
        ;;
    "ai")
        notify-send -t 2000 -i ~/nixos/hosts/default/scripts/resources/rec-button.png "Screen recorder" "Started recording with audio input"
        wf-recorder --audio="alsa_input.pci-0000_00_1f.3.analog-stereo" -f "Videos/recordings/$(date +'%d.%m.%Y_%H:%M:%S').mp4"
        ;;
    *)
        notify-send -t 2000 -i ~/nixos/hosts/default/scripts/resources/rec-button.png "Screen recorder" "Started recording with no audio"
        wf-recorder -f "Videos/recordings/$(date +'%d.%m.%Y_%H:%M:%S').mp4"
        ;;
esac
''
