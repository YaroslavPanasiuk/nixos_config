{ pkgs }:

pkgs.writeShellScriptBin "cleanup.sh" '' 
#!/bin/sh
nix-store --gc
nix-collect-garbage -d
nix-store --gc
''
