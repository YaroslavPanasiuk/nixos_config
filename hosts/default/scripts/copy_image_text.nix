{ pkgs }:

pkgs.writeShellScriptBin "copy_image_text.sh" '' 
#!/usr/bin/env bash

lang=$(echo -e "English 🇺🇸\nUkrainian 🇺🇦" | rofi -dmenu -config ~/.config/rofi/config-lang.rasi)
echo $lang
hyprshot -m region --clipboard-only

if [ "$lang" = 'Ukrainian 🇺🇦' ]; then 
    wl-paste | tesseract -l ukr stdin - | wl-copy
    exit
fi
if [ "$lang" = 'English 🇺🇸' ]; then 
    wl-paste | tesseract -l eng stdin - | wl-copy
    exit
fi
''
