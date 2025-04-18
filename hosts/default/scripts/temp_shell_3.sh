#!/usr/bin/env bash

BAT=`ls /sys/class/power_supply | grep BAT | head -n 1`

battery() {
	cat /sys/class/power_supply/${BAT}/capacity
}
battery_stat() {
	cat /sys/class/power_supply/${BAT}/status
}

case "$1" in
	--bat) battery;;
	--bat-st) battery_stat;;
esac
