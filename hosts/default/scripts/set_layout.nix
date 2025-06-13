{ pkgs }:

pkgs.writeShellScriptBin "set_layout.sh" '' 
#!/bin/sh

layout=$(hyprctl devices -j | jq '.keyboards.[] | select(.main == true).active_keymap' | awk '{print $NF}')

set=0
if [[ $1 = "ua" && "$layout" != '"Ukrainian"' ]]; then 
    layout='(US)"'
    set=1
fi
if [[ $1 = "us" && "$layout" != '(US)"' ]]; then 
    layout='"Ukrainian"'
    set=1
fi
if [[ -n "$1" && $set -eq 0 ]]; then
    exit
fi

if [ $layout == '"Ukrainian"' ]; then
    hyprctl switchxkblayout at-translated-set-2-keyboard 0
    exit
fi
if [ $layout == '(US)"' ]; then
    hyprctl switchxkblayout at-translated-set-2-keyboard 1
    exit
fi
''
