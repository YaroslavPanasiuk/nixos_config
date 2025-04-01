{ pkgs }:

pkgs.writeShellScriptBin "toggle_mpvpaper.sh" '' 
#!/bin/sh

if pidof -qx "mpvpaper"; then
 	pkill mpvpaper
    exit
fi

query=$(swww query)
path="''${query#*/}"
if [[ "''$path" == *"_MP4_"* ]]; then
	mpvpaper -o "no-audio --loop input-ipc-server=/tmp/mpv-socket" eDP-1 "/''${path%.*}.mp4"
fi

''
