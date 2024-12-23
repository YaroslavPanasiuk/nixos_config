{ config, pkgs, inputs, ... }:

{
  imports = [
    ./home-manager/hyprland/hyprland.nix
    ./home-manager/gtk/gtk.nix
    ./home-manager/waybar/waybar.nix
    #./home-manager/dunst/dunst.nix
    ./home-manager/kitty.nix
    #./rofi/colors-rofi.nix
    #./home-manager/firefox.nix
    inputs.pywal-nix.homeManagerModules.x86_64-linux.default
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "yaros";
    stateVersion = "24.11";
    homeDirectory = "/home/yaros";
    packages = with pkgs;[
      davinci-resolve
      (pkgs.writeShellScriptBin "colour-scheme-sample" ''
        echo '${config.pywal-nix.colourScheme.wallpaper}'
        echo '${config.pywal-nix.colourScheme.special.background}'
        echo '${config.pywal-nix.colourScheme.colours.colour0}'
        echo '${config.pywal-nix.colourScheme.colours.colour1}'
        echo '${config.pywal-nix.colourScheme.colours.colour2}'
        echo '${config.pywal-nix.colourScheme.colours.colour3}'
        echo '${config.pywal-nix.colourScheme.colours.colour4}'
        echo '${config.pywal-nix.colourScheme.colours.colour5}'
        echo '${config.pywal-nix.colourScheme.colours.colour6}'
        echo '${config.pywal-nix.colourScheme.colours.colour7}'
        echo '${config.pywal-nix.colourScheme.colours.colour8}'
        echo '${config.pywal-nix.colourScheme.colours.colour9}'
        echo '${config.pywal-nix.colourScheme.colours.colour10}'
        echo '${config.pywal-nix.colourScheme.colours.colour11}'
        echo '${config.pywal-nix.colourScheme.colours.colour12}'
        echo '${config.pywal-nix.colourScheme.colours.colour13}'
        echo '${config.pywal-nix.colourScheme.colours.colour14}'
        echo '${config.pywal-nix.colourScheme.colours.colour15}'
        echo '${config.pywal-nix.colourScheme.special.background}'
        echo '${config.pywal-nix.colourScheme.special.foreground}'
        echo '${config.pywal-nix.colourScheme.special.cursor}'
      '')
    ];
  };

  dconf = {
    enable = true;
    settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  programs.git = {
    enable = true;
    userName  = "YaroslavPanasiuk";
    userEmail = "yaroslav.panasiuk@lnu.edu.ua";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  pywal-nix = {
    wallpaper = ./home-manager/extra_resources/Wallpaper.jpg;                  
  };

  programs.home-manager.enable = true;
}