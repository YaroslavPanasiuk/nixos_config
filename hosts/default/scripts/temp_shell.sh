force=false
file=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--force)
            force=true
            shift # Move to the next argument
            ;;
        *)
            file="$1"
            shift # Move to the next argument
            ;;
    esac
done

if [[ -n "$file" ]]; then
    if [[ -f "$HOME/Public/Wallpapers/$file" ]]; then
        echo "Using image: $file"
        swww img "$HOME/Public/Wallpapers/$file" --transition-fps 60 --transition-type outer --transition-pos 20,1060  --transition-duration 2
    else
        echo "File does not exist: $HOME/Public/Wallpapers/$file"
    fi
else
    echo "No file provided. Proceeding with a random image."
    DIR=~/Public/Wallpapers/
    PICS=($(ls ''${DIR}))
    RANDOMPICS=''${PICS[ $RANDOM % ''${#PICS[@]} ]}
    swww img ''${DIR}/''${RANDOMPICS} --transition-fps 60 --transition-type grow --transition-pos 20,1060  --transition-duration 3
fi

if [[ "$force" == true ]]; then
    echo "The system will rebuild"
    post_setting.sh -f
else
    post_setting.sh
fi