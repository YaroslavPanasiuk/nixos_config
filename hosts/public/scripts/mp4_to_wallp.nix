{ pkgs }:

pkgs.writeShellScriptBin "mp4_to_wallp.sh" '' 
#!/bin/sh

name_file() {
    echo "$extention"
    local folder="$HOME/Public/Wallpapers"  # The folder to check, default is current directory
    local counter=1         # Start numbering files from 1

    # Ensure the extension starts with a dot
    hint=""

    if [[ "$1" == "gif" ]]; then
        hint="GIF"
    fi
    if [[ "$1" == "mp4" ]]; then
        hint="MP4"
    fi

    while true; do
        local filename="$folder/''${counter}_''${hint}_"
        if [[ ! -e "$filename.jpg" ]]; then
            echo $filename
            return 0
        fi
        ((counter++))
    done
}

echo $1
filename=""

if [ "$2" == "gif" ]; then
    filename=$(echo "$(name_file gif)" | tr -d '\n')
    ffmpeg -i $1 -vf "fps=15,scale=1920:-1:flags=lanczos" -c:v gif "$filename.gif"
fi

if [ "$2" == "mp4" ]; then
    filename=$(echo "$(name_file mp4)" | tr -d '\n')
    cp $1 $filename.mp4
fi

ffmpeg -i $1 -vf "select=eq(n\,0)" -q:v 2 -frames:v 1 "$filename.jpg"

echo $filename
''

