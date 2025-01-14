#!/bin/sh

nix-shell -p git --command "git clone https://github.com/YaroslavPanasiuk/nixos_config.git ~/nixos"
echo "done cloning"

mkdir ~/shared
mkdir ~/shared/Projects
mkdir ~/shared/Wallpapers
mkdir ~/Videos/recordings

cp ~/nixos/hosts/default/home-manager/extra_resources/Wallpaper.jpg ~/shared/Wallpapers/1.jpg

cp -rf ~/nixos/dotfiles/kando ~/.config/kando


sudo nixos-generate-config --show-hardware-config > ~/nixos/hosts/default/hardware-configuration.nix
sudo nixos-rebuild switch --flake ~/nixos#default;

swww-daemon
wallp -i ~/nixos/hosts/default/home-manager/extra_resources/Wallpaper.jpg
#wpg-install.sh -gG

git clone --depth 1 https://codeberg.org/thirtysix/walogram.git ~/.walogram
cd ~/.walogram
sudo make install
cd ..
rm -rf ~/.walogram

wallp

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub life.bolls.bolls

