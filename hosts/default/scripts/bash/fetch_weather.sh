#!/usr/bin/env bash
colors_path="$HOME/.cache/wal/colors"
accent_color=$(awk 'NR==3 {print; exit}' "$colors_path")
l="<span color='$accent_color'>║</span>"

remove_equally_spaced_elements() {
    local -a arr=("${!1}")
    length=${#arr[@]}
    N=$(( length - $2 ))
    step=$((length / (N + 1)))

    # Remove elements
    for ((i=1; i<=N; i++)); do
        index=$((i * step - 1))  # -1 because arrays are 0-indexed
        unset "arr[$index]"
    done

    # Rebuild array to remove empty indices
    arr=("${arr[@]}")
    echo "${arr[@]}"
}

get_temp_color() {
    local temp=$(($1 / 10))
    local colors=("#FF0000" "#FF0A00" "#FF1400" "#FF1E00" "#FF2800" "#FF3200" "#FF3C00" "#FF4600" "#FF5000" "#FF5A00" "#FF6400" "#FF6E00" "#FF7800" "#FF8200" "#FF8C00" "#FF9600" "#FFA000" "#FFAA00" "#FFB400" "#FFBE00" "#FFC800" "#FFD200" "#FFDC00" "#FFE600" "#FFF000" "#FFFA00" "#FFFF00" "#FFFF1A" "#FFFF33" "#FFFF4D" "#FFFF66" "#FFFF80" "#FFFF99" "#FFFFB3" "#FFFFCC" "#FFFFE6" "#FFFFFF" "#F0F7FF" "#E0EFFF" "#D1E7FF" "#C2DFFF" "#B3D7FF" "#A4CFFF" "#95C7FF" "#86BFFF" "#77B7FF" "#68AFFF" "#59A7FF" "#4A9FFF" "#3B97FF" "#2C8FFF" "#1D87FF" "#0E7FFF" "#0077FF")
    index=0
    
    for ((i=29; i>=-20; i--)); do
        if (( $temp > $i )); then
            echo ${colors[$index]}
            return
        fi
        index=$(( $index + 1 ))
    done
    echo ${colors[-1]}
}


smooth_array_to_length() {
  local -a arr=("${!1}")
  local target_len=$2

  while [ "${#arr[@]}" -lt "$target_len" ]; do
    arr=($(insert_averages "${arr[@]}"))
  done
  arr=($(remove_equally_spaced_elements arr[@] $target_len))
  echo "${arr[@]}"
}

insert_averages() {
  local input=("$@")
  local output=(${input[0]})

  for ((i = 0; i < ${#input[@]} - 1; i++)); do
    local a=${input[i]}
    local b=${input[i + 1]}
    local avg=$(( (a + b) / 2 ))

    output+=("$a" "$avg")
  done

  # Add the last element
  output+=("${input[-1]}")

  echo "${output[@]}"
}

get_time_coordinates() {
    NOW=$(echo $TIME | cut -d ' ' -f 1)
    TARGET=$1
    MAX=$2

    sec1=$(date -d "$NOW" +%s)
    sec2=$(date -d "$TARGET" +%s)

    diff=$((sec2 - sec1))

    if [[ "$diff" == -* ]]; then
        return -1
    fi

    if (( ($diff / 3600) > $HOURS )); then
        return -1
    fi

    char_time=$(echo "scale=3; $HOURS * 3600 / $MAX" | bc)
    remain_chars=$(echo "scale=0; $diff / $char_time" | bc)
    echo $remain_chars
}

draw_graph() {
    local -a values=("${!1}")
    local width=$2
    local height=$3
    local -a sunrises=("${!4}")
    local -a sunsets=("${!5}")
    local base=$6
    local result=""

    local MAX_VALUE=${values[0]}
    local MIN_VALUE=${values[0]}

    for num in "${values[@]}"; do
        (( num > MAX_VALUE )) && MAX_VALUE=$num
        (( num < MIN_VALUE )) && MIN_VALUE=$num
    done

    if [ "$base" = "zero" ]; then 
        if (( MAX_VALUE <= 0 )); then
            MAX_VALUE=0
        else
            MAX_VALUE=$(echo "($MAX_VALUE / 50 + 1) * 50" | bc)
        fi

        if (( MIN_VALUE > 0 )); then
            MIN_VALUE=0
        else 
            MIN_VALUE=$(echo "($MIN_VALUE / 50 - 1) * 50" | bc)
        fi
    fi

    local range=$((MAX_VALUE - MIN_VALUE))
    if (( range == 0 )); then
        range=1
    fi

    local sunset_coord=()
    local sunrise_coord=()
    for sunset in "${sunsets[@]}"; do
        coord=$(get_time_coordinates $sunset $width)
        [[ -n $coord ]] && sunset_coord+=("$coord")
    done

    for sunrise in "${sunrises[@]}"; do
        coord=$(get_time_coordinates $sunrise $width)
        [[ -n $coord ]] && sunrise_coord+=("$coord")
    done

    local smoothed=($(smooth_array_to_length values[@] $width))

    for i in $(seq $height -1 0); do
        local current_level=$(( MIN_VALUE + (i * range) / height ))
        local current_color=$(get_temp_color $current_level)
        
        if (( i % 5 == 0 )); then
            result+=$(printf "<span color='$current_color'>%-5s</span>$l" "$(echo "scale=1; $current_level / 10" | bc)")
        else
            result+=$(printf "     $l")
        fi
        local char=""
        local lastchar=""
        local x=0
        for v in "${smoothed[@]}"; do
            last_char=$char

            if (( (v >= current_level && current_level >= 0) || (v <= current_level && current_level <= 0) )); then
                char="<span color='$current_color'>█</span>"
            elif (( v < range / height / 2 && v > -range / height / 2 && current_level >= 0  && current_level <= range / height / 2 )); then
                char="<span color='$current_color'>_</span>"
            else
                char=" "
            fi

            local temp_changed="no"
            if [[ ( $last_char == "<span color='$current_color'>█</span>" && $char == " " ) || ( $last_char == " " && $char == "<span color='$current_color'>█</span>" ) ]]; then
                temp_changed="yes"
            fi

            if [[ $temp_changed == "yes" && $current_level -gt 0 ]]; then
                char="<span color='$current_color'>▄</span>"
            fi

            if [[ $temp_changed == "yes" && $current_level -lt 0 ]]; then
                char="<span color='$current_color'>▀</span>"
            fi

            for coord in "${sunrise_coord[@]}"; do
                if [ "$x" -eq "$coord" ]; then
                    if [ "$char" = " " ]; then
                        char="<span color='$current_color'>▐</span>"
                    else
                        char="<span color='$current_color'>▌</span>"
                    fi

                    if [ $i -eq $height ]; then
                        char="🌞"
                    fi
                fi
            done

            for coord in "${sunset_coord[@]}"; do
                if [ "$x" -eq "$coord" ]; then
                    if [ "$char" = " " ]; then
                        char="<span color='$current_color'>▐</span>"
                    else
                        char="<span color='$current_color'>▌</span>"
                    fi

                    if [ $i -eq $height ]; then
                        char="😎"
                    fi
                fi
            done

            if [[ $last_char == "🌞" || $last_char == "😎" ]]; then
                    char=""
            fi

            x=$(($x+1))
            result+=$(printf "$char")
        done
        result+="$l\n$l"
    done

    echo "${result::-30}"

}

# Coordinates for Berlin (change to your location)

LAT=$(curl -s https://ipinfo.io/json | grep -oP '"loc": "\K[^"]+' | cut -d , -f 1)
LON=$(curl -s https://ipinfo.io/json | grep -oP '"loc": "\K[^"]+' | cut -d , -f 2)
LAT="${LAT:=49.835052840224876}"
LON="${LON:=23.997055982804596}"

HOURS=$1
MIN_HOURS=1
MAX_HOURS=100
WIDTH=$(( $HOURS * 8 - 1))
HEIGHT=$2

((HOURS < MIN_HOURS)) && HOURS=$MIN_HOURS
((HOURS > MAX_HOURS)) && HOURS=$MAX_HOURS



# Fetch forecast data from Open-Meteo
HOURLY_VARS="weather_code,temperature_2m"
DAILY_VARS="precipitation_sum,precipitation_hours,precipitation_probability_max,sunrise,sunset&current_weather=true"

FORECAST_JSON=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&hourly=${HOURLY_VARS}&daily=${DAILY_VARS}&forecast_hours=$HOURS&forecast_days=7&timezone=auto")

# Check if API call succeeded
if ! jq -e '.daily' <<< "$FORECAST_JSON" >/dev/null 2>&1; then
    echo "Error: Failed to fetch forecast data"
    exit 1
fi

# Parse today's data
PRECIP_SUM=$(jq -r '.daily.precipitation_sum[0]' <<< "$FORECAST_JSON")
PRECIP_HOURS=$(jq -r '.daily.precipitation_hours[0]' <<< "$FORECAST_JSON")
PRECIP_PROB=$(jq -r '.daily.precipitation_probability_max[0]' <<< "$FORECAST_JSON")

WIND_SPEED=$(jq -r '.current_weather.windspeed' <<< "$FORECAST_JSON")
WIND_DIR=$(jq -r '.current_weather.winddirection' <<< "$FORECAST_JSON")

SUNRISE1=$(jq -r '.daily.sunrise[0]' <<< "$FORECAST_JSON")
SUNSET1=$(jq -r '.daily.sunset[0]' <<< "$FORECAST_JSON")
SUNSET2=$(jq -r '.daily.sunset[1]' <<< "$FORECAST_JSON")
SUNRISE2=$(jq -r '.daily.sunrise[1]' <<< "$FORECAST_JSON")
SUNSET=$(jq -r '.daily.sunset[]' <<< "$FORECAST_JSON")
SUNRISE=$(jq -r '.daily.sunrise[]' <<< "$FORECAST_JSON")

TEMP_HOURLY=$(jq -r '.hourly.temperature_2m[]' <<< "$FORECAST_JSON")
WEATHER_CODE_HOURLY=$(jq -r '.hourly.weather_code[]' <<< "$FORECAST_JSON")
TIME=$(jq -r '.hourly.time[]' <<< "$FORECAST_JSON")

TEMP=$(jq '.current_weather.temperature' <<< "$FORECAST_JSON")
WCODE=$(jq '.current_weather.weathercode' <<< "$FORECAST_JSON")

# Map weather codes to human-readable descriptions
declare -A WEATHER_DESCRIPTION=(
    [0]="☀️ Clear sky"
    [1]="🌤️ Mainly clear"
    [2]="🌤️ Partly cloudy"
    [3]="☁️ Overcast"
    [45]="🌫️ Fog"
    [48]="🌫️ Depositing rime fog"
    [51]="🌧️ Light drizzle"
    [53]="🌧️ Moderate drizzle"
    [55]="🌧️ Dense drizzle"
    [56]="🌧️❄️ Light freezing drizzle"
    [57]="🌧️❄️ Dense freezing drizzle"
    [61]="🌦️ Slight rain"
    [63]="🌧️ Moderate rain"
    [65]="🌧️ Heavy rain"
    [66]="🌧️❄️ Light freezing rain"
    [67]="🌧️❄️ Heavy freezing rain"
    [71]="🌨️ Slight snow fall"
    [73]="🌨️ Moderate snow fall"
    [75]="❄️ Heavy snow fall"
    [77]="🌨️ Snow grains"
    [80]="🌦️ Slight rain showers"
    [81]="🌧️ Moderate rain showers"
    [82]="⛈️ Violent rain showers"
    [85]="🌨️ Slight snow showers"
    [86]="❄️ Heavy snow showers"
    [95]="⛈️ Thunderstorm"
    [96]="⛈️ Thunderstorm with slight hail"
    [99]="⛈️ Thunderstorm with heavy hail"
)

# Get wind direction
if (( WIND_DIR >= 338 || WIND_DIR < 23 )); then WIND_DIR_NAME="N"
elif (( WIND_DIR >= 23 && WIND_DIR < 68 )); then WIND_DIR_NAME="NE"
elif (( WIND_DIR >= 68 && WIND_DIR < 113 )); then WIND_DIR_NAME="E"
elif (( WIND_DIR >= 113 && WIND_DIR < 158 )); then WIND_DIR_NAME="SE"
elif (( WIND_DIR >= 158 && WIND_DIR < 203 )); then WIND_DIR_NAME="S"
elif (( WIND_DIR >= 203 && WIND_DIR < 248 )); then WIND_DIR_NAME="SW"
elif (( WIND_DIR >= 248 && WIND_DIR < 293 )); then WIND_DIR_NAME="W"
else WIND_DIR_NAME="NW"
fi

readarray -t time_array <<< "$TIME"
readarray -t weather_code_array <<< "$WEATHER_CODE_HOURLY"
readarray -t temp_array <<< "$TEMP_HOURLY"
readarray -t sunsets <<< "$SUNSET"
readarray -t sunrises <<< "$SUNRISE"

times=()
temps=()
values=()
emojis=()
lines1=()
lines2=()

for i in "${!time_array[@]}"; do
    emoji=" $(echo ${WEATHER_DESCRIPTION[${weather_code_array[i]}]:0:2})           "
    emojis+=("${emoji:0:6}$l")

    time="${time_array[i]##*T}                                                     "
    times+=("${time:0:6}$l")

    temp="${temp_array[i]}°                                                        "
    temps+=("${temp:0:6}$l")

    if ((i >= MIN_HOURS)); then
        lines1+=("═══════╦")
        lines2+=("═══════╩")
    fi

    temp_num="${temp_array[i]}"
    values+=($(echo "$temp_num * 10" | bc | cut -d '.' -f 1))
done


condition=" ${WEATHER_DESCRIPTION[$WCODE]} $TEMP°C                                                                        "
rain=" Rain: $PRECIP_PROB% ($PRECIP_HOURS hours, ${PRECIP_SUM}mm)                                                         "
wind=" Wind: ${WIND_SPEED}km/h $WIND_DIR_NAME                                                                             "
lines="═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════"
delimiter1=""
delimiter2=""
info=""
if (( $HOURS < 8 )); then
    info="$l${condition:0:$((5+HOURS*8))}$l\n"
    delimiter1="╠═════╩${lines:0:$((HOURS*8-1))}╣\n"
    delimiter2="╚══════${lines:0:$((HOURS*8-1))}╝"
elif (( $HOURS < 11 )); then
    info="$l${condition:0:$((4+HOURS*4))}$l${rain:0:$((HOURS*4))}$l\n"
    delimiter1="╠═════╩${lines:0:$((HOURS*4-2))}╦${lines:0:$((HOURS*4))}╣\n"
    delimiter2="╚══════${lines:0:$((HOURS*4-2))}╩${lines:0:$((HOURS*4))}╝"
else
    info="$l${condition:0:$((3+HOURS*3))}$l${rain:0:$((HOURS*3))}$l${wind:0:$((HOURS*2))}$l\n"
    delimiter1="╠═════╩${lines:0:$((HOURS*3-3))}╦${lines:0:$((HOURS*3))}╦${lines:0:$((HOURS*2))}╣\n"
    delimiter2="╚══════${lines:0:$((HOURS*3-3))}╩${lines:0:$((HOURS*3))}╩${lines:0:$((HOURS*2))}╝"
fi

output=""
output+="<span color='$accent_color'>╔═╦═╦═╦$(printf "%s" "${lines1[@]}")═══════╗</span>\n"
output+="<span color='$accent_color'>║ ╠═╣ ║</span> ${times[@]}\n<span color='$accent_color'>╠═╣ ╠═╣</span> ${emojis[@]}\n<span color='$accent_color'>║ ╠═╣ ║</span> ${temps[@]}\n"
output+="<span color='$accent_color'>╠═╩═╩═╬$(printf "%s" "${lines2[@]}")═══════╣</span>\n$l"
output+="$(draw_graph values[@] $WIDTH $HEIGHT sunrises[@] sunsets[@])"
#output+="<span color='$accent_color'>╠═╦═╦═╬$(printf "%s" "${lines1[@]}")═══════╣</span>\n"
#output+="<span color='$accent_color'>║ ╠═╣ ║</span> ${times[@]}\n<span color='$accent_color'>╠═╣ ╠═╣</span> ${emojis[@]}\n<span color='$accent_color'>║ ╠═╣ ║</span> ${temps[@]}\n"
#output+="<span color='$accent_color'>╠═╩═╩═╬$(printf "%s" "${lines2[@]}")═══════╣</span>\n$l"
#output+="$(draw_graph values[@] $WIDTH $HEIGHT sunrises[@] sunsets[@])"
output+="<span color='$accent_color'>$delimiter1</span>"
output+="$info"
output+="<span color='$accent_color'>$delimiter2</span>"


echo "{\"text\":\"$(echo -e ${WEATHER_DESCRIPTION[$WCODE]:0:2}) $TEMP°\", \"tooltip\":\"$output\"}"