{ pkgs }:

pkgs.writeShellScriptBin "record_screen.sh" '' 
#!/bin/sh

if pidof -qx "wf-recorder"; then
 	pkill -SIGINT wf-recorder 
    dunstify -a "Screen" "Writing file to ~/Videos/recordings/$(date +'%d.%m.%Y_%H:%M:%S').mp4"
    exit
fi

case "$1" in
    "ao")
        dunstify -a "Screen" "Started recording with audio output" 
        wf-recorder --audio="alsa_output.pci-0000_00_1f.3.analog-stereo.monitor" -f "Videos/recordings/$(date +'%d.%m.%Y_%H:%M:%S').mp4"
        ;;
    "ai")
        dunstify -a "Screen" "Started recording with audio input" 
        wf-recorder --audio="alsa_input.pci-0000_00_1f.3.analog-stereo" -f "Videos/recordings/$(date +'%d.%m.%Y_%H:%M:%S').mp4"
        ;;
    *)
        dunstify -a "Screen" "Started recording with no audio" 
        wf-recorder -f "Videos/recordings/$(date +'%d.%m.%Y_%H:%M:%S').mp4"
        ;;
esac
''
