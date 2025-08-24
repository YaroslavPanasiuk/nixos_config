#!/usr/bin/env bash

INPUT_WIDTH=1920
INPUT_HEIGHT=1080
INPUTS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -w) INPUT_WIDTH="$2"; shift 2;;
        -h) INPUT_HEIGHT="$2"; shift 2;;
        -i) shift; while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
                INPUTS+=("$1")
                shift
            done ;;
        *) echo "Unknown option: $1"; exit 1;;
    esac
done

if [[ -z "$INPUT_WIDTH" || -z "$INPUT_HEIGHT" || "${#INPUTS[@]}" -eq 0 ]]; then
    echo "Usage: $0 -w WIDTH -h HEIGHT -i FILE1 FILE2 FILE3 ..."
    exit 1
fi

for path in "${INPUTS[@]}"; do
    echo $path
    filename=$(basename "$path")
    filename_no_ext=${filename%.*}
    extension=${filename##*.}
    dir=$(dirname "$path")

    is_image=$(file --mime-type "$path" | grep -qE 'image/(jpeg|png|gif|bmp|webp|tiff)' && echo 1 || echo 0)
    is_video=$(file --mime-type "$path" | grep -qE 'video/(mp4|x-matroska|quicktime|x-msvideo|x-ms-wmv|webm|ogg)' && echo 1 || echo 0)

    WIDTH=-1
    HEIGHT=-1

    if [ "$is_video" -eq 1 ]; then
        ffmpeg -i $path -vf "select=eq(n\,0)" -q:v 2 -frames:v 1 "$path.jpg"
        WIDTH=$(identify -format "%w" "$path.jpg")
        HEIGHT=$(identify -format "%h" "$path.jpg")
        rm -f "$path.jpg"
    elif [ "$is_image" -eq 1 ]; then
        magick "$path" -auto-orient "$path"
        WIDTH=$(identify -format "%w" "$path")
        HEIGHT=$(identify -format "%h" "$path")
    fi

    RATIO=$(echo "scale=4; $WIDTH/$HEIGHT" | bc)
    TRESHHOLD_RATIO=$(echo "scale=4; $INPUT_WIDTH/$INPUT_HEIGHT" | bc)
    is_wide=$(echo "$RATIO > $TRESHHOLD_RATIO" | bc -l)


    if [[ "$WIDTH" -eq "$INPUT_WIDTH" && "$HEIGHT" -eq "$INPUT_HEIGHT" ]]; then
        cp "$path" "$dir/$filename_no_ext"_blurred".$extension"
        continue
    fi

    if [[ "$is_video" -eq 1 && "$WIDTH" -ne "$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=p=0 "$path" | sed 's/,$//')" ]]; then
        ffmpeg -i $path -vf "rotate=0" -metadata:s:v rotate="0" -c:a copy $path.mp4
        rm -f $path
        mv $path.mp4 $path
    fi

    NEW_WIDTH=$(echo "scale=5; $INPUT_HEIGHT/$HEIGHT*$WIDTH" | bc)
    NEW_WIDTH=$(printf "%.0f" "$(echo "$NEW_WIDTH+0.9999" | bc)")
    if (( NEW_WIDTH % 2 == 1 )); then NEW_WIDTH=$(( NEW_WIDTH - 1 )); fi

    NEW_HEIGHT=$(echo "scale=5; $INPUT_WIDTH/$WIDTH*$HEIGHT" | bc)
    NEW_HEIGHT=$(printf "%.0f" "$(echo "$NEW_HEIGHT+0.9999" | bc)")
    if (( NEW_HEIGHT % 2 == 1 )); then NEW_HEIGHT=$(( NEW_HEIGHT - 1 )); fi

    if [ "$is_wide" -eq 1 ]; then
        WIDTH1=$NEW_WIDTH
        WIDTH2=$INPUT_WIDTH
        HEIGHT2=$NEW_HEIGHT
        HEIGHT1=$INPUT_HEIGHT
    else 
        WIDTH1=$INPUT_WIDTH
        WIDTH2=$NEW_WIDTH
        HEIGHT2=$INPUT_HEIGHT
        HEIGHT1=$NEW_HEIGHT
    fi

    echo "Input: ${WIDTH}x${HEIGHT}, New: ${NEW_WIDTH}x${NEW_HEIGHT}, Target: ${INPUT_WIDTH}x${INPUT_HEIGHT}"
    echo "is_wide: $is_wide, is_image: $is_image, is_video: $is_video"
    echo "RATIO: $RATIO, TRESHHOLD_RATIO: $TRESHHOLD_RATIO"

    if [[ "$is_image" -eq 1 ]]; then
        ffmpeg -y -i "$path" -filter_complex "[0:v]scale=$WIDTH1:$HEIGHT1, gblur=sigma=30[bg]; [0:v]scale=$WIDTH2:$HEIGHT2[fg]; [bg][fg]overlay=(W-w)/2:(H-h)/2[merged]; [merged]crop=$INPUT_WIDTH:$INPUT_HEIGHT:(iw-$INPUT_WIDTH)/2:(ih-$INPUT_HEIGHT)/2[out]" -map "[out]" "$dir/$filename_no_ext"_blurred".$extension"
        continue
    fi

    if [[ "$is_video" -eq 1 ]]; then
        notify-send -t 15000 "Editing Video" "Editing $path... This may take several minutes"
        ffmpeg -y -i "$path" -filter_complex "[0:v]scale=$WIDTH1:$HEIGHT1, gblur=sigma=30[bg]; [0:v]scale=$WIDTH2:$HEIGHT2[fg]; [bg][fg]overlay=(W-w)/2:(H-h)/2[merged]; [merged]crop=$INPUT_WIDTH:$INPUT_HEIGHT:(iw-$INPUT_WIDTH)/2:(ih-$INPUT_HEIGHT)/2[out]" -map "[out]" -map 0:a? -c:v libx264 -crf 18 -preset fast -c:a copy "$dir/$filename_no_ext"_blurred".$extension"
        notify-send -t 5000 "Editing Video" "Successfully added blurred background at $dir/$filename_no_ext"_blurred".$extension"
        continue
    fi

done

notify-send -t 5000 "Blur background" "Successfully finished all operations"
