{ pkgs }:

pkgs.writeShellScriptBin "sync_folders.sh" '' 
#!/bin/bash
rsync -avz --delete "$HOME/Documents/" "/mnt/server_nas/Documents/"
rsync -avz --delete "$HOME/nixos/" "/mnt/server_nas/nixos/"
rsync -avz --delete "$HOME/Public/Wallpapers/" "/mnt/server_nas/Wallpapers/"
''
