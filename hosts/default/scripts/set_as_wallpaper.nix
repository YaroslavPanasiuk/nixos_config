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
    local folder="$HOME/Public/Wallpapers"  # The folder to check, default is current directory
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

case $extension in
    jpg)
        destination=$(echo "$(name_file .jpg)" | tr -d '\n')
        magick "$path" -resize 1920x1080^ -gravity center -extent 1920x1080 "$destination" 
        ;;
    png)
        destination=$(echo "$(name_file .jpg)" | tr -d '\n')
        magick "$path" -resize 1920x1080^ -gravity center -extent 1920x1080 "$destination" 
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
    wallp $(basename "$destination")
fi

''
