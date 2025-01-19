{ pkgs }:

pkgs.writeShellScriptBin "wallp-rofi.sh" '' 
cd ~/Public/Wallpapers
layout_msg.sh us
image="$(for a in *.jpg; do echo -en "$a\0icon\x1f$a\n" ; done | sort -n | rofi -dmenu -config ~/.config/rofi/wallp-config.rasi)"
echo $image
query=$(swww query)
path="''${query#*/}"
if [[ "$image" == "" ]]; then
    exit
fi

if [[ "/$path" == "$HOME/Public/Wallpapers/$image" ]]; then
    exit
fi

swww img ~/Public/Wallpapers/$image --transition-fps 60 --transition-type grow --transition-pos 20,1060  --transition-duration 3   
post_setting.sh &
''
