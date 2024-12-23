{ pkgs }:

pkgs.writeShellScriptBin "rebuild.sh" '' 
#!/bin/sh
echo 1 | sudo -S nixos-rebuild switch --flake ~/nixos/#default
mapfile -t my_array < <(echo 1 | sudo -S nix-env --list-generations --profile /nix/var/nix/profiles/system)
my_array_length=''${#my_array[@]}
generation_number=$(echo "''${my_array[my_array_length-2]}" | awk -v N=1 '{print $N}')
sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations "''${generation_number}"
''
