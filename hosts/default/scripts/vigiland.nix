{ pkgs }:

pkgs.writeShellScriptBin "vigiland.sh" '' 
#!/usr/bin/env bash

if pidof -qx "vigiland"; then
 	notify-send -a "Vigiland" "Idle behavior restored"
 	pkill vigiland
else
    vigiland &
    notify-send -a "Vigiland" "Idle behavior inhibited"
fi
''
