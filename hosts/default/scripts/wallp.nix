{ pkgs }:

pkgs.writeShellScriptBin "wallp.sh" '' 
dir="$HOME/Public/Wallpapers/"
file="$1"

if [[ -n "$file" ]]; then
    if [[ -f "$dir$file" ]]; then
        echo "Using image: $file"
        swww img "$dir$file" --transition-fps 60 --transition-type outer --transition-pos 20,1060  --transition-duration 2
    else
        echo "File does not exist: $dir$file"
    fi
else
    echo "No file provided. Proceeding with a random image."
    PICS=($(ls ''${dir}))
    RANDOMPICS=''${PICS[ $RANDOM % ''${#PICS[@]} ]}
    swww img ''${dir}/''${RANDOMPICS} --transition-fps 60 --transition-type grow --transition-pos 20,1060  --transition-duration 3
fi

pkill -f post_setting.sh
post_setting.sh
''
