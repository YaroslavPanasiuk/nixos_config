#!/usr/bin/env bash

STATE_FILE="/tmp/phone_mic_state"
adb disconnect

if [ -f "$STATE_FILE" ]; then
    source "$STATE_FILE"
    
    kill "$SCRCPY_PID" 2>/dev/null
    pw-dump | jq '.[] | select(.info.props."node.name" == "PhoneMic") | .id' | xargs -r -n 1 pw-cli destroy
    
    rm "$STATE_FILE"
    notify-send "Phone Mic" "Disconnected"
else
    NODE_OUTPUT=$(pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name="PhoneMic" node.description="Phone_Mic" media.class=Audio/Source/Virtual audio.position=[ MONO ] object.linger=true }')    
    adb start-server
    serial_num=$(select_adb_device.sh)
    echo $serial_num
	hotspot=$(adb -s $serial_num shell ip -f inet addr show wlan1 | grep "inet " | awk '{print $2}' | cut -d/ -f1)
	ip=$(adb -s $serial_num shell ip -f inet addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1)
	if [ -z "$ip" ]; then
		ip=$hotspot
	fi
    
	if [ -n "$ip" ]; then
		adb -s $serial_num tcpip 5555
		connected="false"
		for i in {1..10}; do
            sleep 0.5
            if [ "$(adb connect "$ip:5555" | awk '{print $1}')" = "connected" ]; then 
				scrcpy -s $serial_num --no-video --no-window --audio-source=mic > /dev/null 2>&1 &
				connected="true"
				echo "connected via wifi"
				break
			fi
        done
		if [ "$connected" = "false" ]; then 
			scrcpy -s $serial_num --no-video --no-window --audio-source=mic > /dev/null 2>&1 &
			echo "connected via cable"
		fi
	else 
		scrcpy -s $serial_num --no-video --no-window --audio-source=mic > /dev/null 2>&1 &
		echo "connected via cable"
	fi
    SCRCPY_PID=$!
    
    (
        for i in {1..10}; do
            sleep 0.5
            if pw-link -o | grep -qi "SDL Application.*output_FL"; then
                pw-dump | jq -r '
                    [ .[] | select(.info.props."node.name" == "SDL Application") | .id ] as $ids |
                    .[] | select(.type == "PipeWire:Interface:Link") |
                    select((.info.props."link.output.node" | IN($ids[])) or (.info.props."link.input.node" | IN($ids[]))) |
                    .id' | xargs -r -n 1 pw-link -d
                pw-link "SDL Application:output_FL" "PhoneMic:input_MONO"
                pw-link "SDL Application:output_FR" "PhoneMic:input_MONO"
                break
            fi
        done
    ) &
    pactl set-default-source PhoneMic
    
    echo "SCRCPY_PID=$SCRCPY_PID" > "$STATE_FILE"
    
    notify-send "Phone Mic" "Connected"
fi
