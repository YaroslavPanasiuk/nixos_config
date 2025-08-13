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
    local -a rain_hours=("${!6}")
    local base=$6
    local result=""
    local rain_frames=(▗ ▝)
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

    local rain_coords=()
    for rain_hour in "${rain_hours[@]}"; do
        coord=$(get_time_coordinates $rain_hour $width)
        [[ -n $coord ]] && rain_coords+=("$coord")
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

            local char_shows_rain="no"
            for coord in "${rain_coords[@]}"; do
                if [[ "$x" -ge "$coord" && "$x" -le "$(( coord + 8))" ]]; then
                    phase=$((x % ${#rain_frames[@]}))
                    if [ "$char" != " " ]; then
                        char="<span color='#718cc3'>${rain_frames[$phase]}</span>"
                        char_shows_rain="yes"
                    fi
                fi
            done

            for coord in "${sunrise_coord[@]}"; do
                if [ "$x" -eq "$coord" ]; then
                    if [[ ( "$char" == " " ) || ( "$char_shows_rain" = "yes" ) ]]; then
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
                    if [[ ( "$char" == " " ) || ( "$char_shows_rain" = "yes" ) ]]; then
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

while [[ $# -gt 0 ]]; do
    case "$1" in
        --hours) INPUT_HOURS="$2"; shift 2;;
        --height) INPUT_HEIGHT="$2"; shift 2;;
        --city) INPUT_CITY="$2"; shift 2;;
        --lat) INPUT_LAT="$2"; shift 2;;
        --lon) INPUT_LON="$2"; shift 2;;
        --refresh) INPUT_REFRESH="$2"; shift 2;;
        *) shift 2;;
    esac
done

while true; do
    # Coordinates for Berlin (change to your location)
    if [[ -n "$INPUT_LAT" && -n "$INPUT_LON" ]]; then
        LAT=$INPUT_LAT
        LON=$INPUT_LON
        CITY="$(curl -s "https://nominatim.openstreetmap.org/reverse?format=json&lat=$LAT&lon=$LON" | jq -r '.address.city // .address.town // .address.village // .address.municipality // .address.county')"
    elif [ -n "$INPUT_CITY" ]; then
        LAT=$(curl -s "https://nominatim.openstreetmap.org/search?q=$INPUT_CITY&format=json" | jq -r '.[0] | .lat + "," + .lon' | cut -d , -f 1)
        LON=$(curl -s "https://nominatim.openstreetmap.org/search?q=$INPUT_CITY&format=json" | jq -r '.[0] | .lat + "," + .lon' | cut -d , -f 2)
        CITY="$(curl -s "https://nominatim.openstreetmap.org/reverse?format=json&lat=$LAT&lon=$LON" | jq -r '.address.city // .address.town // .address.village // .address.municipality // .address.county')"
    else
        LAT=$(curl -s https://ipinfo.io/json | grep -oP '"loc": "\K[^"]+' | cut -d , -f 1)
        LON=$(curl -s https://ipinfo.io/json | grep -oP '"loc": "\K[^"]+' | cut -d , -f 2)
        CITY="$(curl -s "https://nominatim.openstreetmap.org/reverse?format=json&lat=$LAT&lon=$LON" | jq -r '.address.city // .address.town // .address.village // .address.municipality // .address.county')"
    fi

    LAT="${LAT:=49.835052840224876}"
    LON="${LON:=23.997055982804596}"
    CITY="${CITY:=Дрогобич}"
    HOURS="${INPUT_HOURS:=12}"
    HEIGHT="${INPUT_HEIGHT:=6}"
    REFRESH="${INPUT_REFRESH:=1200}"

    MIN_HOURS=1
    MAX_HOURS=100
    WIDTH=$(( $HOURS * 8 - 1))

    ((HOURS < MIN_HOURS)) && HOURS=$MIN_HOURS
    ((HOURS > MAX_HOURS)) && HOURS=$MAX_HOURS



    # Fetch forecast data from Open-Meteo
    HOURLY_VARS="weather_code,temperature_2m"
    DAILY_VARS="precipitation_sum,precipitation_hours,precipitation_probability_max,sunrise,sunset&current_weather=true"

    FORECAST_JSON=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&hourly=${HOURLY_VARS}&daily=${DAILY_VARS}&forecast_hours=$HOURS&forecast_days=7&timezone=auto")
    # Check if API call succeeded
    if ! jq -e '.daily' <<< "$FORECAST_JSON" >/dev/null 2>&1; then
        echo "{\"text\":\"<span size='12pt'>󰔪 </span>\", \"tooltip\":\"Error: Failed to fetch forecast data\"}"
        exit
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
    if (( WIND_DIR >= 338 || WIND_DIR < 23 )); then WIND_DIR_NAME="󰁆"
    elif (( WIND_DIR >= 23 && WIND_DIR < 68 )); then WIND_DIR_NAME="󰦸"
    elif (( WIND_DIR >= 68 && WIND_DIR < 113 )); then WIND_DIR_NAME="󰁎"
    elif (( WIND_DIR >= 113 && WIND_DIR < 158 )); then WIND_DIR_NAME="󰧄"
    elif (( WIND_DIR >= 158 && WIND_DIR < 203 )); then WIND_DIR_NAME="󰁞"
    elif (( WIND_DIR >= 203 && WIND_DIR < 248 )); then WIND_DIR_NAME="󰧆"
    elif (( WIND_DIR >= 248 && WIND_DIR < 293 )); then WIND_DIR_NAME="󰁕"
    else WIND_DIR_NAME="󰦺"
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
    rain_hours=()

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

        if ((weather_code_array[i] > 50)); then
            rain_hours+=("${time_array[$i]}")
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

    output1=""
    output2=""
    output3=""
    output1+="<span color='$accent_color'>╔═╦═╦═╦$(printf "%s" "${lines1[@]}")═══════╗</span>\n"
    output1+="<span color='$accent_color'>╠═╩═╩═╣</span> ${times[@]}\n"    
    output2+=" ${emojis[@]}\n<span color='$accent_color'>╠═╦═╦═╣</span> ${temps[@]}\n"
    output2+="<span color='$accent_color'>╠═╩═╩═╬$(printf "%s" "${lines2[@]}")═══════╣</span>\n$l"
    graph="$(draw_graph values[@] $WIDTH $HEIGHT sunrises[@] sunsets[@] rain_hours[@])"
    output3+="<span color='$accent_color'>$delimiter1</span>"
    output3+="$info"
    output3+="<span color='$accent_color'>$delimiter2</span>"

    time=0
    step=0.5

    if [ "${#CITY}" -gt "5" ]; then
        slide="$CITY  "

        while true; do
            for (( i=0; i<${#slide}; i++ )); do
                append=$(( i + 5 - ${#slide} ))
                append=$(( $append > 0 ? $append : 0 ))
                part="${slide:i:5}${slide:0:$append}"
                echo "{\"text\":\"$(echo -e ${WEATHER_DESCRIPTION[$WCODE]:0:2}) $TEMP°\", \"tooltip\":\"$output1$l$part$l$output2$graph$output3\"}"

                if [[ "${#rain_hours[@]}" -ne 0 ]]; then
                    graph="${graph//▗/▘}"
                    graph="${graph//▝/▗}"
                    graph="${graph//▘/▝}"
                fi
                sleep $step
                time=$(echo "$time + $step" | bc)
            done
            if [ $(echo "$time >= $REFRESH" | bc -l) -eq 1 ]; then
                echo "{\"text\":\"$(echo -e ${WEATHER_DESCRIPTION[$WCODE]:0:2}) $TEMP°\", \"tooltip\":\"$output1$l${slide:0:5}$l$output2$graph$output3\"}"
                break
            fi
        done
    
    else
        slide="$CITY     "
        if [[ "${#rain_hours[@]}" -ne 0 ]]; then
            while true; do
                echo "{\"text\":\"$(echo -e ${WEATHER_DESCRIPTION[$WCODE]:0:2}) $TEMP°\", \"tooltip\":\"$output1$l${slide:0:5}$l$output2$graph$output3\"}"
                graph="${graph//▗/▘}"
                graph="${graph//▝/▗}"
                graph="${graph//▘/▝}"
                sleep $step
                time=$(echo "$time + $step" | bc)
                if [ $(echo "$time >= $REFRESH" | bc -l) -eq 1 ]; then
                    break
                fi
            done
        else
            echo "{\"text\":\"$(echo -e ${WEATHER_DESCRIPTION[$WCODE]:0:2}) $TEMP°\", \"tooltip\":\"$output1$l${slide:0:5}$l$output2$graph$output3\"}"
            sleep $REFRESH
        fi
    fi
done