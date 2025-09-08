{ pkgs}:

pkgs.writeShellScriptBin "backup.sh" '' 
#!/bin/sh

mkdir ~/backup

sed -i "s/$USER/__user__/g" ~/nixos/hosts/default/configuration_modules/user.nix

cp -rf ~/.config ~/backup
cp -rf ~/Public ~/backup
cp -rf ~/Documents ~/backup
cp -rf ~/nixos ~/backup

cp -rf ~/backup /run/media/$USER/yaros_usb
cp -rf ~/virtual /run/media/$USER/yaros_usb
cp ~/Public/CurrentWallpaper/BlurredBackground.png /run/media/$USER/yaros_usb/ventoy/themes/bigsur/background.png

cd ~/nixos
git add .
git commit -m "message"
git push -f origin main

cd ~/Documents/test
git add .
git commit -m "message"
git push -f origin main

sed -i "s/__user__/$USER/g" ~/nixos/hosts/default/configuration_modules/user.nix


''
