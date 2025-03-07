{ pkgs }:

pkgs.writeShellScriptBin "post_setting.sh" '' 
#!/bin/sh

pkill mpvpaper

query=$(swww query | tail -n1 | awk '{print $NF}')
path="''${query#*/}"
echo $path
gif="false"
mp4="false"
if [[ "$path" == *"_GIF_"* ]]; then
	path="''${path%.*}.jpg"
	gif="true"
fi
if [[ "$path" == *"_MP4_"* ]]; then
	path="''${path%.*}.jpg"
	mp4="true"
fi
echo $path
wpg -s "/''${path}"
wal -i "/''${path}"

if pidof -qx "rofi"; then
 	pkill rofi
 	rofi -show drun -config ~/.config/wofi/config.rasi # && echo "set rofi"
fi

cat ~/.cache/wal/colors | while read -r color; do
  echo -en "\e]P''${color:1}\e\\"
done

launch_dock.sh &
pkill -f -37 nwg-dock-hyprland

colors=()
while IFS= read -r line; do
    colors+=("$line")
done < ~/.cache/wal/colors

cp ~/.cache/wal/kando-config.json ~/.config/kando/config.json
cp "/$path" ~/Public/CurrentWallpaper/Windows/Background1.jpg
cp "/$path" ~/Public/CurrentWallpaper/Windows/Background2.jpg
convert /$path ~/Public/CurrentWallpaper/Background.png
magick /$path -blur 0x10 -fill black -colorize 50% ~/Public/CurrentWallpaper/BlurredBackground.jpg
cp ~/Public/CurrentWallpaper/BlurredBackground.jpg ~/nixos/hosts/default/grub/bigsur/background.jpg
convert ~/Public/CurrentWallpaper/BlurredBackground.jpg ~/Public/CurrentWallpaper/BlurredBackground.png
cp ~/Public/CurrentWallpaper/BlurredBackground.png /run/media/$USER/yaros_usb/ventoy/themes/bigsur/background.png
magick /$path -blur 0x17 -fill black -colorize 70% ~/Public/CurrentWallpaper/VeryBlurredBackground.jpg
cp ~/Public/CurrentWallpaper/VeryBlurredBackground.jpg ~/nixos/hosts/default/home-manager/extra_resources/VeryBlurredBackground.jpg
cp "/$path" ~/nixos/hosts/default/home-manager/extra_resources/Wallpaper.jpg

#sed -i "s/\(\"action-icon-color\":\s*\)\"[^\"]*\"\(,\?\)/\1\"''${colors[15]}\"\2/" ~/.config/kando/config.json
#sed -i "s/\(\"submenu-icon-color\":\s*\)\"[^\"]*\"\(,\?\)/\1\"''${colors[3]}\"\2/" ~/.config/kando/config.json
#sed -i "s/\(\"background-color\":\s*\)\"[^\"]*\"\(,\?\)/\1\"''${colors[0]}\"\2/" ~/.config/kando/config.json
#sed -i "s/\(\"text-color\":\s*\)\"[^\"]*\"\(,\?\)/\1\"''${colors[15]}\"\2/" ~/.config/kando/config.json

kando --reload-menu-theme &
update_telegram.sh -B -i ~/nixos/hosts/default/home-manager/extra_resources/Wallpaper.jpg
pkill dunst
if ! pidof -qx "hyprpanel"; then
 	hyprpanel &
fi
hyprpanel useTheme ~/.cache/wal/hyprbar.json
#reload_firefox.sh
set_welcome.sh
#push_sddm.sh
#push_wallp.sh

if [ "$1" = "-f" ]; then 
    rebuild.sh
fi

if [[ "$gif" == "true" ]]; then
	echo gif
	swww img /"''${path%.*}.gif"
	exit
fi

if [[ "$mp4" == "true" ]]; then
	echo mp4
	mpvpaper -o "no-audio --loop input-ipc-server=/tmp/mpv-socket" eDP-1 "/''${path%.*}.mp4" &
	exit
fi

notify-send "Wallpaper change" "Wallpaper set successfully"
exit
''
