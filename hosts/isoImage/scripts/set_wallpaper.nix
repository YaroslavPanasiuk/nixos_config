{ pkgs }:

pkgs.writeShellScriptBin "set_wallpaper.sh" '' 
#!/bin/sh

swww query || swww-daemon
swww img $1 --transition-fps 60 --transition-type grow --transition-pos 20,1060  --transition-duration 3

~/.config/waybar/post_setting.sh 
''
