{ pkgs}:

pkgs.writeShellScriptBin "backup.sh" '' 
#!/bin/sh

mkdir ~/backup

cp -rf ~/.cache ~/backup
cp -rf ~/.config ~/backup
cp -rf ~/Public ~/backup
cp -rf ~/Documents ~/backup
cp -rf ~/nixos ~/backup

sed -i "s/$USER/__user__/g" ~/backup/nixos/hosts/default/configuration_modules/user.nix
sed -i "s/$HOME/__home__/g" ~/backup/nixos/hosts/default/configuration_modules/user.nix

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

''
