{ pkgs }:

pkgs.writeShellScriptBin "post_setting.sh" '' 
#!/bin/sh

pkill mpvpaper
#kill "''${processes[-1]}"

query=$(swww query)
path="''${query#*/}"
echo $path
gif="false"
mp4="false"
if [[ "''$path" == *"_GIF_"* ]]; then
	path="''${path%.*}.jpg"
	gif="true"
fi
if [[ "''$path" == *"_MP4_"* ]]; then
	path="''${path%.*}.jpg"
	mp4="true"
fi
echo $path
wpg -s "/''${path}"
wal -i "/''${path}"
#restart_thunar.sh 
#echo "set waybar"
if pidof -qx "rofi"; then
 	pkill rofi
 	rofi -show drun -config ~/.config/wofi/config.rasi # && echo "set rofi"
fi

cat ~/.cache/wal/colors | while read -r color; do
  echo -en "\e]P${color:1}\e\\"
done

#pkill -f nwg-dock-hyprland
launch_dock.sh &
pkill -f -37 nwg-dock-hyprland

cp ~/.cache/wal/kando-config.json ~/.config/kando/config.json 
cp "/$path" ~/Public/CurrentWallpaper/Windows/Background1.jpg
cp "/$path" ~/Public/CurrentWallpaper/Windows/Background2.jpg
convert /$path ~/Public/CurrentWallpaper/Background.png
magick /$path -blur 0x10 -fill black -colorize 50% ~/Public/CurrentWallpaper/BlurredBackground.jpg
cp ~/Public/CurrentWallpaper/BlurredBackground.jpg ~/nixos/hosts/default/grub/bigsur/background.jpg
convert ~/Public/CurrentWallpaper/BlurredBackground.jpg ~/Public/CurrentWallpaper/BlurredBackground.png
cp ~/Public/CurrentWallpaper/BlurredBackground.png /run/media/slavko/yaros_usb/ventoy/themes/bigsur/background.png
magick /$path -blur 0x17 -fill black -colorize 70% ~/Public/CurrentWallpaper/VeryBlurredBackground.jpg
cp "/$path" ~/nixos/hosts/default/home-manager/extra_resources/Wallpaper.jpg
#cp "/$path" ~/.mozilla/firefox/o3ylylpw.default/chrome/styles/ASSETS/wallpaper/wallpaper.png

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
