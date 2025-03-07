{ pkgs}:

pkgs.writeShellScriptBin "blur_video.sh" '' 
#!/usr/bin/env bash

for path in "$@"; do
    notify-send -t 15000 "Editing Video" "Editing $path... This may take several minutes"
    filename=$(basename "$path")
    filename_no_ext=''${filename%.*}
    extension=''${filename##*.}
    dir=$(dirname "$path")

    WIDTH=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=p=0 "$path")
    HEIGHT=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 "$path")
    echo "Width: $WIDTH, Height: $HEIGHT"
    RATIO=$(echo "scale=4; $WIDTH/$HEIGHT" | bc)
    TRESHHOLD_RATIO=$(echo "scale=4; 1920/1080" | bc)

    echo $RATIO
    echo $TRESHHOLD_RATIO

    NEW_WIDTH=$(echo "scale=5; 1080/$HEIGHT*$WIDTH" | bc)
    NEW_WIDTH=$(printf "%.0f" "$(echo "$NEW_WIDTH+0.9999" | bc)")
    if (( NEW_WIDTH % 2 == 1 )); then NEW_WIDTH=$(( NEW_WIDTH - 1 )); fi
    echo $NEW_WIDTH

    NEW_HEIGHT=$(echo "scale=5; 1920/$WIDTH*$HEIGHT" | bc)
    NEW_HEIGHT=$(printf "%.0f" "$(echo "$NEW_HEIGHT+0.9999" | bc)")
    if (( NEW_HEIGHT % 2 == 1 )); then NEW_HEIGHT=$(( NEW_HEIGHT - 1 )); fi
    echo $NEW_HEIGHT

    if (( $(echo "$RATIO > $TRESHHOLD_RATIO" | bc -l) )); then
        ffmpeg -y -i "$path" -filter_complex "[0:v]scale=$NEW_WIDTH:1080, gblur=sigma=30[bg]; [0:v]scale=1920:$NEW_HEIGHT[fg]; [bg][fg]overlay=(W-w)/2:(H-h)/2[merged]; [merged]crop=1920:1080:(iw-1920)/2:(ih-1080)/2[out]" -map "[out]" -map 0:a? -c:v libx264 -crf 18 -preset fast -c:a copy "$dir/$filename_no_ext"_edited".$extension"
    else
        ffmpeg -y -i "$path" -filter_complex "[0:v]scale=1920:$NEW_HEIGHT, gblur=sigma=30[bg]; [0:v]scale=$NEW_WIDTH:1080[fg]; [bg][fg]overlay=(W-w)/2:(H-h)/2[merged]; [merged]crop=1920:1080:(iw-1920)/2:(ih-1080)/2[out]" -map "[out]" -map 0:a? -c:v libx264 -crf 18 -preset fast -c:a copy "$dir/$filename_no_ext"_edited".$extension"
    fi
done

notify-send -t 5000 "Editing Video" "Successfully added blurred background at $dir/$filename_no_ext"_edited".$extension"
''


