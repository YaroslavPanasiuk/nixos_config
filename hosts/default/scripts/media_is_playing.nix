{ pkgs }:

pkgs.writeShellScriptBin "media_is_playing.sh" '' 
#!/usr/bin/env bash

if playerctl status --all-players 2>/dev/null | grep -q "Playing"; then
    echo "Media is playing"
    exit 1
else
    echo "No media playing"
    exit 0
fi
''
