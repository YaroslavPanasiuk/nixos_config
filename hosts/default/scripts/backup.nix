{ pkgs}:

pkgs.writeShellScriptBin "backup.sh" '' 
#!/bin/sh

mkdir ~/backup
cp -rf ~/.cache ~/backup
cp -rf ~/.config ~/backup
cp -rf ~/shared ~/backup
cp -rf ~/Documents ~/backup
cp -rf ~/nixos ~/backup

cp -rf ~/.config/dunst ~/nixos/dotfiles
cp -rf ~/.config/rofi ~/nixos/dotfiles
cp -rf ~/.config/vlc ~/nixos/dotfiles
cp -rf ~/.config/wal ~/nixos/dotfiles
cp -rf ~/.config/walogram ~/nixos/dotfiles
cp -rf ~/.config/kando ~/nixos/dotfiles

cp -rf ~/backup /run/media/yaros/yaros_usb/yaros_backup

cd ~/nixos
git add .
git commit -m "message"
git push -f origin main
''
