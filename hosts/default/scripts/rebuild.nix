{ pkgs }:

pkgs.writeShellScriptBin "rebuild.sh" '' 
#!/bin/sh

cd ~/nixos
git add .
if [[ "$1" == "--rollback" ]]; then
    sudo nixos-rebuild switch --rollback --flake ~/nixos/#default
    mapfile -t my_array < <(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system)
    my_array_length=''${#my_array[@]}
    generation_number=$(echo "''${my_array[my_array_length-1]}" | awk -v N=1 '{print $N}')
    sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations "''${generation_number}"
    exit
fi
sudo nixos-rebuild switch --flake ~/nixos/#default


''
