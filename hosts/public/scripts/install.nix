{ pkgs }:

pkgs.writeShellScriptBin "install.sh" '' 
nix-shell -p git --command "nix run --experimental-features 'nix-command flakes' github:YaroslavPanasiuk/nixos_config"
''
