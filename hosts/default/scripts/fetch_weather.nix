{ pkgs }:

pkgs.writeShellScriptBin "fetch_weather.sh" '' 
#!/usr/bin/env bash
colors_path="$HOME/.cache/wal/colors"
accent_color=$(awk 'NR==3 {print; exit}' "$colors_path" 2>/dev/null || echo "#FFFFFF")
l="<span color='$accent_color'>║</span>"

remove_equally_spaced_elements() {
    local -a arr=("''${!1}")
    local length=''${#arr[@]}
    local N=$(( length - $2 ))
    if (( N <= 0 )); then
        echo "''${arr[@]}"
        return
    fi
    local step=$((length / (N + 1)))

    for ((i=1; i<=N; i++)); do
        local index=$((i * step - 1))
        unset "arr[$index]"
    done

    arr=("''${arr[@]}")
    echo "''${arr[@]}"
}

get_temp_color() {
    local temp=$(( $1 / 10 ))
    local colors=("#FF0000" "#FF0A00" "#FF1400" "#FF1E00" "#FF2800" "#FF3200" "#FF3C00" "#FF4600" "#FF5000" "#FF5A00" "#FF6400" "#FF6E00" "#FF7800" "#FF8200" "#FF8C00" "#FF9600" "#FFA000" "#FFAA00" "#FFB400" "#FFBE00" "#FFC800" "#FFD200" "#FFDC00" "#FFE600" "#FFF000" "#FFFA00" "#FFFF00" "#FFFF1A" "#FFFF33" "#FFFF4D" "#FFFF66" "#FFFF80" "#FFFF99" "#FFFFB3" "#FFFFCC" "#FFFFE6" "#FFFFFF" "#F0F7FF" "#E0EFFF" "#D1E7FF" "#C2DFFF" "#B3D7FF" "#A4CFFF" "#95C7FF" "#86BFFF" "#77B7FF" "#68AFFF" "#59A7FF" "#4A9FFF" "#3B97FF" "#2C8FFF" "#1D87FF" "#0E7FFF" "#0077FF")
    local index=0
    
    for ((i=29; i>=-20; i--)); do
        if (( temp > i )); then
            echo "''${colors[$index]}"
            return
        fi
        index=$(( index + 1 ))
    done
    echo "''${colors[-1]}"
}

smooth_array_to_length() {
    local -a arr=("''${!1}")
    local target_len=$2

    while (( ''${#arr[@]} < target_len )); do
        arr=($(insert_averages "''${arr[@]}"))
    done
    arr=($(remove_equally_spaced_elements arr[@] $target_len))
    echo "''${arr[@]}"
}

insert_averages() {
    local input=("$@")
    local output=(''${input[0]})

    for ((i = 0; i < ''${#input[@]} - 1; i++)); do
        local a=''${input[i]}
        local b=''${input[i + 1]}
        local avg=$(( (a + b) / 2 ))
        output+=("$a" "$avg")
    done

    output+=("''${input[-1]}")
    echo "''${output[@]}"
}

get_time_coordinates() {
    local target_sec=$(date -d "''${1//T/ }" +%s 2>/dev/null || echo 0)
    local diff=$(( target_sec - current_sec ))

    if (( diff < 0 || diff > HOURS * 3600 )); then
        return
    fi
    echo $(( diff * MAX_WIDTH / (HOURS * 3600) ))
}

draw_graph() {
    local -a values=("''${!1}")
    local width=$2
    local height=$3
    local -a sunrises=("''${!4}")
    local -a sunsets=("''${!5}")
    local -a rain_hours=("''${!6}")
    local base=$6
    local result=""
    local rain_frames=(▗ ▝)
    local MAX_VALUE=''${values[0]}
    local MIN_VALUE=''${values[0]}

    for num in "''${values[@]}"; do
        (( num > MAX_VALUE )) && MAX_VALUE=$num
        (( num < MIN_VALUE )) && MIN_VALUE=$num
    done

    if [ "$base" = "zero" ]; then 
        if (( MAX_VALUE <= 0 )); then
            MAX_VALUE=0
        else
            MAX_VALUE=$(( (MAX_VALUE / 50 + 1) * 50 ))
        fi

        if (( MIN_VALUE > 0 )); then
            MIN_VALUE=0
        else 
            MIN_VALUE=$(( (MIN_VALUE / 50 - 1) * 50 ))
        fi
    fi

    local range=$(( MAX_VALUE - MIN_VALUE ))
    (( range == 0 )) && range=1

    local sunset_coord=()
    local sunrise_coord=()
    local rain_coords=()

    for sunset in "''${sunsets[@]}"; do
        coord=$(get_time_coordinates "$sunset")
        [[ -n $coord ]] && sunset_coord+=("$coord")
    done

    for sunrise in "''${sunrises[@]}"; do
        coord=$(get_time_coordinates "$sunrise")
        [[ -n $coord ]] && sunrise_coord+=("$coord")
    done

    for rain_hour in "''${rain_hours[@]}"; do
        coord=$(get_time_coordinates "$rain_hour")
        [[ -n $coord ]] && rain_coords+=("$coord")
    done

    local smoothed=($(smooth_array_to_length values[@] $width))

    for i in $(seq $height -1 0); do
        local current_level=$(( MIN_VALUE + (i * range) / height ))
        local current_color=$(get_temp_color $current_level)
        
        if (( i % 5 == 0 )); then
            local int_p=$(( current_level / 10 ))
            local frac_p=$(( current_level % 10 ))
            frac_p=''${frac_p#-}
            local val_str="''${int_p}.''${frac_p}"
            result+=$(printf "<span color='%s'>%-5s</span>%s" "$current_color" "$val_str" "$l")
        else
            result+=$(printf "     $l")
        fi

        local char=""
        local last_char=""
        local x=0

        for v in "''${smoothed[@]}"; do
            last_char=$char

            if (( v >= current_level )); then
                char="<span color='$current_color'>█</span>"
            else
                char=" "
            fi

            if [[ ( $last_char == "<span color='$current_color'>█</span>" && $char == " " ) || ( $last_char == " " && $char == "<span color='$current_color'>█</span>" ) ]]; then
                char="<span color='$current_color'>▄</span>"
            fi

            local char_shows_rain="no"
            for coord in "''${rain_coords[@]}"; do
                if (( x >= coord && x <= coord + 8 )); then
                    phase=$(( x % ''${#rain_frames[@]} ))
                    if [[ "$char" != " " ]]; then
                        char="<span color='#718cc3'>''${rain_frames[$phase]}</span>"
                        char_shows_rain="yes"
                    fi
                fi
            done

            for coord in "''${sunrise_coord[@]}"; do
                if (( x == coord )); then
                    if [[ "$char" == " " || "$char_shows_rain" == "yes" ]]; then
                        char="<span color='$current_color'>▐</span>"
                    else
                        char="<span color='$current_color'>▌</span>"
                    fi
                    (( i == height )) && char="🌞"
                fi
            done

            for coord in "''${sunset_coord[@]}"; do
                if (( x == coord )); then
                    if [[ "$char" == " " || "$char_shows_rain" == "yes" ]]; then
                        char="<span color='$current_color'>▐</span>"
                    else
                        char="<span color='$current_color'>▌</span>"
                    fi
                    (( i == height )) && char="😎"
                fi
            done

            if [[ $last_char == "🌞" || $last_char == "😎" ]]; then
                char=""
            fi

            x=$(( x + 1 ))
            result+="$char"
        done
        result+="$l\n$l"
    done

    echo "''${result::-30}"
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
    if [[ -n "$INPUT_LAT" && -n "$INPUT_LON" ]]; then
        LAT=$INPUT_LAT
        LON=$INPUT_LON
        CITY="$(curl -s --max-time 5 "https://nominatim.openstreetmap.org/reverse?format=json&lat=$LAT&lon=$LON" | jq -r '.address.city // .address.town // .address.village // .address.municipality // .address.county')"
    elif [[ -n "$INPUT_CITY" ]]; then
        read -r LAT LON <<< "$(curl -s --max-time 5 "https://nominatim.openstreetmap.org/search?q=$INPUT_CITY&format=json" | jq -r '.[0] | "\(.lat) \(.lon)"')"
        CITY="$(curl -s --max-time 5 "https://nominatim.openstreetmap.org/reverse?format=json&lat=$LAT&lon=$LON" | jq -r '.address.city // .address.town // .address.village // .address.municipality // .address.county')"
    else
        read -r LAT LON <<< "$(curl -s --max-time 5 https://ipinfo.io/json | jq -r '.loc | split(",") | "\(.[0]) \(.[1])"')"
        CITY="$(curl -s --max-time 5 "https://nominatim.openstreetmap.org/reverse?format=json&lat=$LAT&lon=$LON" | jq -r '.address.city // .address.town // .address.village // .address.municipality // .address.county')"
    fi

    LAT="''${LAT:=49.8383}"
    LON="''${LON:=24.0232}"
    CITY="''${CITY:=Lviv}"
    HOURS="''${INPUT_HOURS:=12}"
    HEIGHT="''${INPUT_HEIGHT:=6}"
    REFRESH="''${INPUT_REFRESH:=1200}"

    (( HOURS < 1 )) && HOURS=1
    (( HOURS > 100 )) && HOURS=100
    MAX_WIDTH=$(( HOURS * 8 - 1 ))

    HOURLY_VARS="weather_code,temperature_2m"
    DAILY_VARS="precipitation_sum,precipitation_hours,precipitation_probability_max,sunrise,sunset&current_weather=true"

    FORECAST_JSON=$(curl -s --max-time 10 "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&hourly=''${HOURLY_VARS}&daily=''${DAILY_VARS}&forecast_hours=$HOURS&forecast_days=7&timezone=auto")
    
    if [[ -z "$FORECAST_JSON" ]] || ! jq -e '.daily' <<< "$FORECAST_JSON" >/dev/null 2>&1; then
        echo "{\"text\":\"<span size='12pt'>󰔪 </span>\", \"tooltip\":\"Error: Failed to fetch forecast data\"}"
        sleep "$REFRESH"
        continue
    fi

    read -r PRECIP_SUM PRECIP_HOURS PRECIP_PROB WIND_SPEED WIND_DIR TEMP WCODE <<< $(jq -r '[.daily.precipitation_sum[0], .daily.precipitation_hours[0], .daily.precipitation_probability_max[0], .current_weather.windspeed, .current_weather.winddirection, .current_weather.temperature, .current_weather.weathercode] | @tsv' <<< "$FORECAST_JSON")

    readarray -t SUNSET < <(jq -r '.daily.sunset[]' <<< "$FORECAST_JSON")
    readarray -t SUNRISE < <(jq -r '.daily.sunrise[]' <<< "$FORECAST_JSON")
    readarray -t TIME < <(jq -r '.hourly.time[]' <<< "$FORECAST_JSON")
    readarray -t WEATHER_CODE_HOURLY < <(jq -r '.hourly.weather_code[]' <<< "$FORECAST_JSON")
    
    # Pre-scale temperatures to integer logic (*10)
    readarray -t values < <(jq -r '.hourly.temperature_2m[]' <<< "$FORECAST_JSON" | awk '{printf "%.0f\n", $1 * 10}')

    declare -A WEATHER_DESCRIPTION=(
        [0]="☀️ Clear sky" [1]="🌤️ Mainly clear" [2]="🌤️ Partly cloudy" [3]="☁️ Overcast"
        [45]="🌫️ Fog" [48]="🌫️ Depositing rime fog" [51]="🌧️ Light drizzle" [53]="🌧️ Moderate drizzle"
        [55]="🌧️ Dense drizzle" [56]="🌧️❄️ Light freezing drizzle" [57]="🌧️❄️ Dense freezing drizzle"
        [61]="🌦️ Slight rain" [63]="🌧️ Moderate rain" [65]="🌧️ Heavy rain" [66]="🌧️❄️ Light freezing rain"
        [67]="🌧️❄️ Heavy freezing rain" [71]="🌨️ Slight snow fall" [73]="🌨️ Moderate snow fall"
        [75]="❄️ Heavy snow fall" [77]="🌨️ Snow grains" [80]="🌦️ Slight rain showers"
        [81]="🌧️ Moderate rain showers" [82]="⛈️ Violent rain showers" [85]="🌨️ Slight snow showers"
        [86]="❄️ Heavy snow showers" [95]="⛈️ Thunderstorm" [96]="⛈️ Thunderstorm with slight hail"
        [99]="⛈️ Thunderstorm with heavy hail"
    )

    WIND_DIR=''${WIND_DIR%.*}
    if (( WIND_DIR >= 338 || WIND_DIR < 23 )); then WIND_DIR_NAME="󰁆"
    elif (( WIND_DIR >= 23 && WIND_DIR < 68 )); then WIND_DIR_NAME="󰦸"
    elif (( WIND_DIR >= 68 && WIND_DIR < 113 )); then WIND_DIR_NAME="󰁎"
    elif (( WIND_DIR >= 113 && WIND_DIR < 158 )); then WIND_DIR_NAME="󰧄"
    elif (( WIND_DIR >= 158 && WIND_DIR < 203 )); then WIND_DIR_NAME="󰁞"
    elif (( WIND_DIR >= 203 && WIND_DIR < 248 )); then WIND_DIR_NAME="󰧆"
    elif (( WIND_DIR >= 248 && WIND_DIR < 293 )); then WIND_DIR_NAME="󰁕"
    else WIND_DIR_NAME="󰦺"
    fi

    times=()
    temps=()
    emojis=()
    lines1=()
    lines2=()
    rain_hours=()
    current_sec=$(date -d "''${TIME[0]//T/ }" +%s 2>/dev/null || echo 0)

    for i in "''${!TIME[@]}"; do
        emoji=" $(echo ''${WEATHER_DESCRIPTION[''${WEATHER_CODE_HOURLY[i]}]:0:2})            "
        emojis+=("''${emoji:0:6}$l")

        time="''${TIME[i]##*T}                                                       "
        times+=("''${time:0:6}$l")

        temp_num=$(awk '{printf "%.1f\n", $1 / 10}' <<< "''${values[i]}")
        temp="''${temp_num}°                                                        "
        temps+=("''${temp:0:6}$l")

        if (( i >= 1 )); then
            lines1+=("═══════╦")
            lines2+=("═══════╩")
        fi

        if (( WEATHER_CODE_HOURLY[i] > 50 )); then
            rain_hours+=("''${TIME[$i]}")
        fi
    done

    condition=" ''${WEATHER_DESCRIPTION[$WCODE]} $TEMP°C                                                                 "
    rain=" Rain: $PRECIP_PROB% ($PRECIP_HOURS hours, ''${PRECIP_SUM}mm)                                                  "
    wind=" Wind: ''${WIND_SPEED}km/h $WIND_DIR_NAME                                                                      "
    lines="═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════"
    
    if (( HOURS < 8 )); then
        info="$l''${condition:0:$((5+HOURS*8))}$l\n"
        delimiter1="╠═════╩''${lines:0:$((HOURS*8-1))}╣\n"
        delimiter2="╚══════''${lines:0:$((HOURS*8-1))}╝"
    elif (( HOURS < 11 )); then
        info="$l''${condition:0:$((4+HOURS*4))}$l''${rain:0:$((HOURS*4))}$l\n"
        delimiter1="╠═════╩''${lines:0:$((HOURS*4-2))}╦''${lines:0:$((HOURS*4))}╣\n"
        delimiter2="╚══════''${lines:0:$((HOURS*4-2))}╩''${lines:0:$((HOURS*4))}╝"
    else
        info="$l''${condition:0:$((3+HOURS*3))}$l''${rain:0:$((HOURS*3))}$l''${wind:0:$((HOURS*2))}$l\n"
        delimiter1="╠═════╩''${lines:0:$((HOURS*3-3))}╦''${lines:0:$((HOURS*3))}╦''${lines:0:$((HOURS*2))}╣\n"
        delimiter2="╚══════''${lines:0:$((HOURS*3-3))}╩''${lines:0:$((HOURS*3))}╩''${lines:0:$((HOURS*2))}╝"
    fi

    output1="<span color='$accent_color'>╔═╦═╦═╦$(printf "%s" "''${lines1[@]}")═══════╗</span>\n"
    output1+="<span color='$accent_color'>╠═╩═╩═╣</span> ''${times[@]}\n"   
    output2=" ''${emojis[@]}\n<span color='$accent_color'>╠═╦═╦═╣</span> ''${temps[@]}\n"
    output2+="<span color='$accent_color'>╠═╩═╩═╬$(printf "%s" "''${lines2[@]}")═══════╣</span>\n$l"
    graph="$(draw_graph values[@] $MAX_WIDTH $HEIGHT SUNRISE[@] SUNSET[@] rain_hours[@])"
    output3="<span color='$accent_color'>$delimiter1</span>$info<span color='$accent_color'>$delimiter2</span>"

    time_elapsed=0
    step=1

    if (( ''${#CITY} > 5 )); then
        slide="$CITY  "
        while true; do
            for (( i=0; i<''${#slide}; i++ )); do
                append=$(( i + 5 - ''${#slide} ))
                (( append < 0 )) && append=0
                part="''${slide:i:5}''${slide:0:$append}"
                echo "{\"text\":\"$(echo -e ''${WEATHER_DESCRIPTION[$WCODE]:0:2}) $TEMP°\", \"tooltip\":\"$output1$l$part$l$output2$graph$output3\"}"

                if (( ''${#rain_hours[@]} != 0 )); then
                    graph="''${graph//▗/▘}"
                    graph="''${graph//▝/▗}"
                    graph="''${graph//▘/▝}"
                fi
                sleep "$step"
                time_elapsed=$(( time_elapsed + step ))
            done
            if (( time_elapsed >= REFRESH )); then
                echo "{\"text\":\"$(echo -e ''${WEATHER_DESCRIPTION[$WCODE]:0:2}) $TEMP°\", \"tooltip\":\"$output1$l''${slide:0:5}$l$output2$graph$output3\"}"
                break
            fi
        done
    else
        slide="$CITY     "
        if (( ''${#rain_hours[@]} != 0 )); then
            while true; do
                echo "{\"text\":\"$(echo -e ''${WEATHER_DESCRIPTION[$WCODE]:0:2}) $TEMP°\", \"tooltip\":\"$output1$l''${slide:0:5}$l$output2$graph$output3\"}"
                graph="''${graph//▗/▘}"
                graph="''${graph//▝/▗}"
                graph="''${graph//▘/▝}"
                sleep "$step"
                time_elapsed=$(( time_elapsed + step ))
                (( time_elapsed >= REFRESH )) && break
            done
        else
            echo "{\"text\":\"$(echo -e ''${WEATHER_DESCRIPTION[$WCODE]:0:2}) $TEMP°\", \"tooltip\":\"$output1$l''${slide:0:5}$l$output2$graph$output3\"}"
            sleep "$REFRESH"
        fi
    fi
done
''