{ pkgs }:

pkgs.writeShellScriptBin "wallpaper_change.sh" '' 
#!/bin/sh
DIR=~/Public/Wallpapers/
PICS=($(ls ''${DIR}))

RANDOMPICS=''${PICS[ $RANDOM % ''${#PICS[@]} ]}

swww img ''${DIR}/''${RANDOMPICS} --transition-fps 60 --transition-type grow --transition-pos 20,1060  --transition-duration 3

post_setting.sh &
''
