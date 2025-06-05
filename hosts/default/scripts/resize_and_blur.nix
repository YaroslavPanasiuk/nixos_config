{ pkgs }:

pkgs.writeShellScriptBin "resize_and_blur.sh" '' 
#!/usr/bin/env bash

INPUT_WIDTH=1920
INPUT_HEIGHT=1080
INPUTS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -w) INPUT_WIDTH="$2"; shift 2;;
        -h) INPUT_HEIGHT="$2"; shift 2;;
        -i) shift; while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
                echo "$1"
                INPUTS+=("$1")
                shift
            done ;;
        *) echo "Unknown option: $1"; exit 1;;
    esac
done

if [[ -z "$INPUT_WIDTH" || -z "$INPUT_HEIGHT" || "''${#INPUTS[@]}" -eq 0 ]]; then
    echo "Usage: $0 -w WIDTH -h HEIGHT -i FILE1 FILE2 FILE3 ..."
    exit 1
fi

for path in "''${INPUTS[@]}"; do
    echo $path
    filename=$(basename "$path")
    filename_no_ext=''${filename%.*}
    extension=''${filename##*.}
    dir=$(dirname "$path")

    WIDTH=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=p=0 "$path" | sed 's/,$//')
    HEIGHT=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 "$path" | sed 's/,$//')
    RATIO=$(echo "scale=4; $WIDTH/$HEIGHT" | bc)
    TRESHHOLD_RATIO=$(echo "scale=4; $INPUT_WIDTH/$INPUT_HEIGHT" | bc)
    is_wide=$(echo "$RATIO > $TRESHHOLD_RATIO" | bc -l)
    is_image=$(file --mime-type "$path" | grep -qE 'image/(jpeg|png|gif|bmp|webp|tiff)' && echo 1 || echo 0)
    is_video=$(file --mime-type "$path" | grep -qE 'video/(mp4|x-matroska|quicktime|x-msvideo|x-ms-wmv|webm|ogg)' && echo 1 || echo 0)



    NEW_WIDTH=$(echo "scale=5; $INPUT_HEIGHT/$HEIGHT*$WIDTH" | bc)
    NEW_WIDTH=$(printf "%.0f" "$(echo "$NEW_WIDTH+0.9999" | bc)")
    if (( NEW_WIDTH % 2 == 1 )); then NEW_WIDTH=$(( NEW_WIDTH - 1 )); fi
    echo $NEW_WIDTH

    NEW_HEIGHT=$(echo "scale=5; $INPUT_WIDTH/$WIDTH*$HEIGHT" | bc)
    NEW_HEIGHT=$(printf "%.0f" "$(echo "$NEW_HEIGHT+0.9999" | bc)")
    if (( NEW_HEIGHT % 2 == 1 )); then NEW_HEIGHT=$(( NEW_HEIGHT - 1 )); fi
    echo $NEW_HEIGHT

    if [[ "$is_wide" -eq 1 && "$is_image" -eq 1 ]]; then
        ffmpeg -y -i "$path" -filter_complex "[0:v]scale=$NEW_WIDTH:$INPUT_HEIGHT, gblur=sigma=30[bg]; [0:v]scale=$INPUT_WIDTH:$NEW_HEIGHT[fg]; [bg][fg]overlay=(W-w)/2:(H-h)/2[merged]; [merged]crop=$INPUT_WIDTH:$INPUT_HEIGHT:(iw-$INPUT_WIDTH)/2:(ih-$INPUT_HEIGHT)/2[out]" -map "[out]" "$dir/$filename_no_ext"_blurred".$extension"
        continue
    fi

    if [[ "$is_wide" -eq 1 && "$is_video" -eq 1 ]]; then
        notify-send -t 15000 "Editing Video" "Editing $path... This may take several minutes"
        ffmpeg -y -i "$path" -filter_complex "[0:v]scale=$NEW_WIDTH:$INPUT_HEIGHT, gblur=sigma=30[bg]; [0:v]scale=$INPUT_WIDTH:$NEW_HEIGHT[fg]; [bg][fg]overlay=(W-w)/2:(H-h)/2[merged]; [merged]crop=$INPUT_WIDTH:$INPUT_HEIGHT:(iw-$INPUT_WIDTH)/2:(ih-$INPUT_HEIGHT)/2[out]" -map "[out]" -map 0:a? -c:v libx264 -crf 18 -preset fast -c:a copy "$dir/$filename_no_ext"_blurred".$extension"
        notify-send -t 5000 "Editing Video" "Successfully added blurred background at $dir/$filename_no_ext"_blurred".$extension"
        continue
    fi

    if [[ "$is_wide" -eq 0 && "$is_image" -eq 1 ]]; then
        ffmpeg -y -i "$path" -filter_complex "[0:v]scale=$INPUT_WIDTH:$NEW_HEIGHT, gblur=sigma=30[bg]; [0:v]scale=$NEW_WIDTH:$INPUT_HEIGHT[fg]; [bg][fg]overlay=(W-w)/2:(H-h)/2[merged]; [merged]crop=$INPUT_WIDTH:$INPUT_HEIGHT:(iw-$INPUT_WIDTH)/2:(ih-$INPUT_HEIGHT)/2[out]" -map "[out]" "$dir/$filename_no_ext"_blurred".$extension"
        continue
    fi

    if [[ "$is_wide" -eq 0 && "$is_video" -eq 1 ]]; then
        notify-send -t 15000 "Editing Video" "Editing $path... This may take several minutes"
        ffmpeg -y -i "$path" -filter_complex "[0:v]scale=$INPUT_WIDTH:$NEW_HEIGHT, gblur=sigma=30[bg]; [0:v]scale=$NEW_WIDTH:$INPUT_HEIGHT[fg]; [bg][fg]overlay=(W-w)/2:(H-h)/2[merged]; [merged]crop=$INPUT_WIDTH:$INPUT_HEIGHT:(iw-$INPUT_WIDTH)/2:(ih-$INPUT_HEIGHT)/2[out]" -map "[out]" -map 0:a? -c:v libx264 -crf 18 -preset fast -c:a copy "$dir/$filename_no_ext"_blurred".$extension"
        notify-send -t 5000 "Editing Video" "Successfully added blurred background at $dir/$filename_no_ext"_blurred".$extension"
        continue
    fi
done

notify-send -t 5000 "Blur background" "Successfully finished all operations"

''