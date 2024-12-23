#!/bin/sh

nix-shell -p git --command "git clone https://github.com/YaroslavPanasiuk/nixos_config.git ~/nixos"
echo "done cloning"

mkdir ~/shared
mkdir ~/shared/Projects
mkdir ~/shared/Wallpapers

cp ~/nixos/hosts/default/home-manager/extra_resources/Wallpaper.jpg ~/shared/Wallpapers/1.jpg
cp -r ~/nixos/dotfiles/vlc ~/.config/vlc
cp -r ~/nixos/dotfiles/wal ~/.config/wal
cp -r ~/nixos/dotfiles/rofi ~/.config/rofi
cp -r ~/nixos/dotfiles/walogram ~/.cache/walogram



sudo nixos-generate-config --show-hardware-config > ~/nixos/hosts/default/hardware-configuration.nix
sudo nixos-rebuild switch --flake ~/nixos#default;

wal -i ~/nixos/hosts/default/home-manager/extra_resources/Wallpaper.jpg
wpg-install.sh -gG

wallp

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub life.bolls.bolls

