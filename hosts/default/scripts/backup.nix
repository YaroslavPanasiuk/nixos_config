{ pkgs}:

pkgs.writeShellScriptBin "backup.sh" '' 
#!/bin/sh

read -p "Which branch to push? ('m' - main, 'l' - legion): " branch

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

if [ $branch == 'm' ]; then
    git switch main
    git add .
    git commit -m "message"
    git push -f origin main
elif [ $branch == 'l' ]; then
    git switch legion
    git add .
    git commit -m "message"
    git push -f origin legion
fi

sed -i "s/__user__/$USER/g" ~/nixos/hosts/default/configuration_modules/user.nix


''
