#!/bin/sh

host="default"
if [ -n "$1" ]; then 
    host=$1
fi
rm -rf ~/nixos
nix-shell -p git --command "git clone https://github.com/YaroslavPanasiuk/nixos_config.git ~/nixos"
echo "done cloning"

sed -i "s/__user__/$USER/g" ~/nixos/hosts/$host/configuration_modules/user.nix

mkdir ~/Public/Wallpapers
mkdir ~/Public/CurrentWallpaper
mkdir ~/Public/CurrentWallpaper/Windows
mkdir ~/Videos/recordings

cp ~/nixos/hosts/$host/home-manager/extra_resources/Wallpaper.jpg ~/Public/Wallpapers/1.jpg

cp -f ~/nixos/dotfiles/kando/config.json ~/.config/kando/config.json

sudo nixos-generate-config --show-hardware-config > ~/nixos/hosts/$host/hardware-configuration.nix
sudo nixos-rebuild switch --install-bootloader --flake ~/nixos#$host;

swww-daemon
swww img ~/Public/Wallpapers/1.jpg
wal -i ~/nixos/hosts/$host/home-manager/extra_resources/Wallpaper.jpg
wpg-install.sh -gG

git clone --depth 1 https://codeberg.org/thirtysix/walogram.git ~/.walogram
cd ~/.walogram
sudo make install
cd ..
rm -rf ~/.walogram

git clone https://github.com/YaroslavPanasiuk/obsidian.git ~/Documents/test

wallp

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub life.bolls.bolls

cd ~/nixos
git remote remove origin
git remote add origin git@github.com:YaroslavPanasiuk/nixos_config.git

cd ~/Documents/test
git remote remove origin
git remote add origin git@github.com:YaroslavPanasiuk/obsidian.git
#generate_ssh.sh

sudo smbpasswd -a $USER