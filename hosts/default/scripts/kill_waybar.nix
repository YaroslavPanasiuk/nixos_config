{ pkgs }:

pkgs.writeShellScriptBin "kill_waybar.sh" '' 
#!/bin/sh
sed -i  's/^.*"wlr\/taskbar",.*$/"wlr\/taskbar",/' "$HOME/.config/waybar/config.jsonc"
pkill waybar
''
