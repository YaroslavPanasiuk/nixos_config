{ pkgs }:

pkgs.writeShellScriptBin "rebuild.sh" '' 
#!/bin/sh

cd ~/nixos
git add .
rm /home/$USER/.config/mimeapps.list.backup
if [[ "$1" == "--rollback" ]]; then
    sudo nixos-rebuild switch --rollback --flake ~/nixos/#default
    generation_number=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -n 1 | awk '{print $1}')
    sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations "''${generation_number}"
    exit
fi
sudo nixos-rebuild switch --flake ~/nixos/#default
#kitty --title "reloading wallpaper" wallp current
''
