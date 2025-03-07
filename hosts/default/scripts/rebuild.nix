{ pkgs }:

pkgs.writeShellScriptBin "rebuild.sh" '' 
#!/bin/sh

cd ~/nixos
git add .
sudo nixos-rebuild switch --flake ~/nixos/#default
if [[ "$1" != "-r" ]]; then
    exit
fi
mapfile -t my_array < <(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system)
my_array_length=''${#my_array[@]}
generation_number=$(echo "''${my_array[my_array_length-2]}" | awk -v N=1 '{print $N}')
sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations "''${generation_number}"
''
