#!/usr/bin/env bash

# Coordinates for Berlin (change to your location)

LAT=$(curl -s https://ipinfo.io/json | grep -oP '"loc": "\K[^"]+' | cut -d , -f 1)
LON=$(curl -s https://ipinfo.io/json | grep -oP '"loc": "\K[^"]+' | cut -d , -f 2)
LAT="${LAT:=49.835052840224876}"
LON="${LON:=23.997055982804596}"

DATA=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&current_weather=true")
TEMP=$(echo $DATA | jq '.current_weather.temperature')
WCODE=$(echo $DATA | jq '.current_weather.weathercode')

# Weather code mapping (simplified)
case $WCODE in
    0) ICON="☀️"; DESC="Clear";;
    1|2|3) ICON="⛅"; DESC="Partly cloudy";;
    45|48) ICON="🌫️"; DESC="Fog";;
    51|53|55) ICON="🌧️"; DESC="Drizzle";;
    61|63|65) ICON="🌧️"; DESC="Rain";;
    71|73|75) ICON="❄️"; DESC="Snow";;
    80|81|82) ICON="🌦️"; DESC="Showers";;
    95|96|99) ICON="⛈️"; DESC="Thunderstorm";;
    *) ICON="🏗️"; DESC="Unknown";;
esac

echo "{\"text\":\"$ICON $TEMP°\", \"tooltip\":\"$DESC\"}"