{ pkgs }:

pkgs.writeShellScriptBin "watchdog.sh" '' 
#!/bin/bash

declare -A SYNC_MAP

SYNC_MAP["$HOME/Documents/"]="/mnt/server_nas/Documents/"
SYNC_MAP["$HOME/nixos/"]="/mnt/server_nas/nixos/"
SYNC_MAP["$HOME/Public/Wallpapers"]="/mnt/server_nas/Wallpapers/"

for LOCAL_DIR in "''${!SYNC_MAP[@]}"; do
    REMOTE_TARGET="''${SYNC_MAP[$LOCAL_DIR]}"
    
    inotifywait -m -r -e modify,create,delete,move "$LOCAL_DIR" |
    while read -r path action file; do
        rsync -avz --delete "$LOCAL_DIR" "$REMOTE_TARGET"
    done &
done

wait
''
