{ pkgs }:

pkgs.writeShellScriptBin "push_wallp.sh" '' 
#!/bin/sh

cd ~/shared/CurrentWallpaper
git add .
git commit -m "wallp_change"
git push -f origin main

''
