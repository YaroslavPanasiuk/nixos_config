{ pkgs }:

pkgs.writeShellScriptBin "post_setting.sh" '' 
#!/bin/sh

current_pid=$$
readarray -t processes < <(ps aux | grep "/bin/sh /home/yaros/.config/waybar/post_setting.sh" | awk '{print $2}')
for pid in "''${processes[@]}"; do
	if [ $current_pid != $pid ]; then
		kill -9 $pid
	fi
done
pkill .gnome-system-m
pkill nix-build
#kill "''${processes[-1]}"

query=$(swww query)
path="''${query#*/}"
echo $path
gif="false"
if [[ "''${path##*.}" == "gif" ]]; then
	path="''${path%.*}.jpg"
	gif="true"
fi
echo $path
wpg -s "/$path"
wal -i "/$path"
#~/.config/waybar/restart_thunar.sh 
#echo "set waybar"
if pidof -qx "rofi"; then
 	pkill rofi
 	rofi -show drun -config ~/.config/wofi/config.rasi # && echo "set rofi"
fi
cp ~/.cache/wal/dunstrc ~/.config/dunst 
cp ~/.cache/wal/colors-sddm.conf ~/nixos/hosts/default/sddm/sddm-sugar-dark/theme.conf
cp ~/.cache/wal/_variables.css ~/.mozilla/firefox/tmaao28u.default/chrome/styles/_variables.css
cp "/$path" ~/nixos/hosts/default/sddm/sddm-sugar-dark/Background.jpg
cp "/$path" ~/shared/CurrentWallpaper/Background1.jpg
cp "/$path" ~/shared/CurrentWallpaper/Background2.jpg
cp "/$path" /home/yaros/nixos/hosts/default/home-manager/extra_resources/Wallpaper.jpg
cp "/$path" ~/.mozilla/firefox/tmaao28u.default/chrome/styles/ASSETS/wallpaper/wallpaper.png

pkill dunst 
~/.config/waybar/update_telegram.sh -B -i ~/shared/CurrentWallpaper/Background1.jpg
~/Documents/reload_firefox.sh
~/Documents/set_welcome.sh
#~/Documents/push_sddm.sh
if [ "$1" = "-f" ]; then 
    ~/Documents/rebuild.sh
	xfconf-query -c xsettings -p /Net/ThemeName -s "Gruvbox-Dark"
	xfconf-query -c xsettings -p /Net/ThemeName -s "linea-nord-color"
fi

#if [ "$gif" = "true" ]; then
	#swww img ~/shared/Wallpapers/"''${path%.*}.gif"
#fi
exit
''
