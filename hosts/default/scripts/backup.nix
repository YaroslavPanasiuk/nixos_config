{ pkgs}:

pkgs.writeShellScriptBin "backup.sh" '' 
#!/bin/sh

mkdir ~/backup

sed -i "s/$USER/__user__/g" ~/nixos/hosts/default/configuration_modules/user.nix

cp -rf ~/.cache ~/backup
cp -rf ~/.config ~/backup
cp -rf ~/Public ~/backup
cp -rf ~/Documents ~/backup
cp -rf ~/nixos ~/backup

cp -rf ~/.config/touchegg ~/nixos/dotfiles

cp -rf ~/backup /run/media/$USER/yaros_usb/$USER_backup

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
