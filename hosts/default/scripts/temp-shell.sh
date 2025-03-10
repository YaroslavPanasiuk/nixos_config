#!/usr/bin/env bash

  status=$(nmcli g | tail -n 1 | awk '{print $1}')
  signal=$(nmcli dev wifi | rg "\*" | awk '{ print $8 }')
  essid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)

  icons=("󰤯" "󰤟" "󰤢" "󰤥" "󰤨")

  if [ "$status" = "disconnected" ] ; then
    icon="󰤭"
    text=""
    color="#988ba2"
  else
    level=$(awk -v n="$signal" 'BEGIN{print int(n)}')
    if [ "$level" -gt 4 ]; then
      level=4
    fi

    icon=${icons[$level]}
    color="#cba6f7"
  fi

case $1 in
	--COL) echo $color;;
	--ESSID) echo $essid;;
	--ICON) echo $icon;;
esac

