{ pkgs }:

pkgs.writeShellScriptBin "kill_taskbar.sh" '' 
#!/bin/sh
WAYBAR_CONFIG="$HOME/.config/waybar/config.jsonc"
count=$(hyprctl clients | grep 'ID:' | wc -l)
if [ $count -gt 14 ]; then
  sed -i 's/"wlr\/taskbar",/\/"wlr\/taskbar",/' "$WAYBAR_CONFIG"
  pkill -USR2 waybar 
fi
''
