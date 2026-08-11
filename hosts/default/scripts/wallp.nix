{ pkgs }:

pkgs.writeShellScriptBin "wallp.sh" '' 
#!/usr/bin/env bash

file=$1
dir="$HOME/Public/Wallpapers/"

if [[ $1 == "current" ]]; then
    file=$(basename $(awww query | grep "eDP-1" | awk '{print $NF}'))
fi

if [[ ! -f "$dir$file" ]]; then
    echo "No file provided. Proceeding with a random image."
    PICS=($(ls ''${dir}))
    RANDOMPICS=''${PICS[ $RANDOM % ''${#PICS[@]} ]}
    wallp.sh ''${RANDOMPICS}
    exit 1
fi

WIDTH=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=noprint_wrappers=1:nokey=1 "$dir$file")
HEIGHT=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=noprint_wrappers=1:nokey=1 "$dir$file")
RATIO=$(echo "scale=2; $WIDTH / $HEIGHT" | bc)
THRESHOLD=3.5


if [[ -f "$dir$file" ]]; then
    echo "Using image: $file"

    if (( $(echo "$RATIO > $THRESHOLD" | bc -l) )); then
        echo "is ultrawide"
        OUT_L="eDP-1"
        OUT_R="DP-1"
        HALF_WIDTH=$(( WIDTH / 2 ))
        LEFT_PART="/tmp/wp_left.jpg"
        RIGHT_PART="/tmp/wp_right.jpg"
        magick "$dir$file" -crop "''${HALF_WIDTH}x''${HEIGHT}+0+0" "$LEFT_PART"
        magick "$dir$file" -crop "''${HALF_WIDTH}x''${HEIGHT}+''${HALF_WIDTH}+0" "$RIGHT_PART"
        awww img "$LEFT_PART" --transition-fps 60 --transition-type wave --transition-pos 20,1060  --transition-duration 2 --outputs "$OUT_L"
        awww img "$RIGHT_PART" --transition-fps 60 --transition-type wave --transition-pos 20,1060  --transition-duration 2 --outputs "$OUT_R"
    else
        awww img "$dir$file" --transition-fps 60 --transition-type outer --transition-pos 20,1060  --transition-duration 2
    fi
else
    echo "file does not exist: $dir$file"
fi


pkill -f post_setting.sh
post_setting.sh
''
