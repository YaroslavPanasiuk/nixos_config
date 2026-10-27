{ config, pkgs, inputs, ... }:
let
  user = import ./configuration_modules/user.nix;
in
{
  imports = [
    ./home-manager/hyprland/hyprland.nix
    ./home-manager/hyprland/hyprlock.nix
    ./home-manager/hyprland/hypridle.nix
    ./home-manager/gtk/gtk.nix
    ./home-manager/waybar/waybar.nix
    #./home-manager/waybar/taskbar.nix
    #./home-manager/dunst/dunst.nix
    ./home-manager/kitty.nix
    #./rofi/colors-rofi.nix
    ./home-manager/xdg.nix
    #./home-manager/gbar.nix
    ./home-manager/services.nix
    ./home-manager/dconf.nix
    ./home-manager/git.nix
    ./home-manager/ssh.nix
    ./home-manager/anyrun/anyrun.nix
    ./home-manager/swayosd/swayosd.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "${user.name}";
    stateVersion = "26.05";
    homeDirectory = "${user.path}";
    packages = with pkgs;[
      #inputs.hyprswitch.packages.x86_64-linux.default
    ];
    file."Templates" = {
      source = ./home-manager/Templates;
      recursive = true;
    };
  };
  services.mpris-proxy.enable = true;
  programs.home-manager.enable = true;
}
