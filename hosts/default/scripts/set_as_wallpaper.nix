{ pkgs }:

pkgs.writeShellScriptBin "set_as_wallpaper.sh" '' 
#!/bin/sh

path=$1
extension="''${path##*.}"
echo $extension
parent_folder=$(dirname "$path")

if [[ $parent_folder"" == "$HOME/Public/Wallpapers" ]]; then
    wallp $(basename "$path")
    exit
fi

name_file() {
    local folder="$HOME/Public/Wallpapers"
    local counter=1         # Start numbering files from 1

    while true; do
        local filename="$folder/$counter$1"
        if [[ ! -e "$filename" ]]; then
            echo $filename
            return 0
        fi
        ((counter++))
    done
}

destination=""

WIDTH=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=noprint_wrappers=1:nokey=1 "$path")
HEIGHT=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=noprint_wrappers=1:nokey=1 "$path")
RATIO=$(echo "scale=2; $WIDTH / $HEIGHT" | bc)
THRESHOLD=3.5

case $extension in
    jpg)
        destination=$(echo "$(name_file .jpg)" | tr -d '\n')
        if (( $(echo "$RATIO > $THRESHOLD" | bc -l) )); then
            magick "$path" -resize 3840x1080^ -gravity center -extent 3840x1080 "$destination" 
        else
            magick "$path" -resize 1920x1080^ -gravity center -extent 1920x1080 "$destination" 
        fi
        ;;
    png)
        destination=$(echo "$(name_file .jpg)" | tr -d '\n')
        if (( $(echo "$RATIO > $THRESHOLD" | bc -l) )); then
            magick "$path" -resize 3840x1080^ -gravity center -extent 3840x1080 "$destination" 
        else
            magick "$path" -resize 1920x1080^ -gravity center -extent 1920x1080 "$destination" 
        fi
        ;;
    gif)
        destination=$(echo "$(name_file _GIF_.jpg)" | tr -d '\n')
        mp4_to_wallp.sh $path gif
        ;;
    mp4)
        destination=$(echo "$(name_file _MP4_.jpg)" | tr -d '\n')
        mp4_to_wallp.sh $path mp4
        ;;
    *)
        exit
        ;;
esac

if [[ -n "$destination" ]]; then
    echo $destination
    wallp.sh $(basename "$destination")
fi

''
