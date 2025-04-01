{ pkgs }:

pkgs.writeShellScriptBin "alttab.sh" '' 
count=$(hyprctl clients | grep 'ID:' | wc -l)
lines=$(expr $count / 5 + 1) 
if [ $lines -gt 8 ]; then
  lines=8
fi
rofi -show window -config ~/nixos/hosts/default/rofi/alttab.rasi -theme-str "#listview { lines: ''${lines}; }"
''
