{ pkgs }:

pkgs.writeShellScriptBin "cleanup.sh" '' 
#!/bin/sh
sudonix-store --gc
nix-collect-garbage -d --delete-older-than 30d
''
