{ pkgs}:

pkgs.writeShellScriptBin "backup.sh" '' 
#!/bin/sh

mkdir ~/backup
cp -rf ~/.cache ~/backup
cp -rf ~/.config ~/backup
cp -rf ~/shared ~/backup
cp -rf ~/Documents ~/backup
cp -rf ~/nixos ~/backup

cp -rf ~/.config/kando ~/nixos/dotfiles
cp -rf ~/.config/touchegg ~/nixos/dotfiles

cp -rf ~/backup /run/media/yaros/yaros_usb/yaros_backup

cd ~/nixos
git add .
git commit -m "message"
git push -f origin main
''
