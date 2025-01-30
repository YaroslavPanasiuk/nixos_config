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
    #./home-manager/stylix.nix
    #./rofi/colors-rofi.nix
    #./home-manager/firefox.nix
    ./home-manager/hyprland/hyprpanel.nix
    ./home-manager/xdg.nix
    ./home-manager/services.nix
    ./home-manager/dconf.nix
    ./home-manager/programs/git.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "${user.name}";
    stateVersion = "24.11";
    homeDirectory = "${user.path}";
    packages = with pkgs;[
      #davinci-resolve
      #hyprpanel
    ];
  };

  programs.home-manager.enable = true;
}
