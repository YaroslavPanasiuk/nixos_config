{ config, pkgs, inputs, ... }:

{
  imports = [
    ./home-manager/hyprland/hyprland.nix
    ./home-manager/gtk/gtk.nix
    #./home-manager/waybar/waybar.nix
    ./home-manager/waybar/taskbar.nix
    #./home-manager/dunst/dunst.nix
    ./home-manager/kitty.nix
    ./home-manager/stylix.nix
    #./rofi/colors-rofi.nix
    #./home-manager/firefox.nix
    #inputs.pywal-nix.homeManagerModules.x86_64-linux.default
    ./home-manager/hyprpanel.nix
    ./home-manager/xdg.nix

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
      hyprpanel
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

  #programs.ags = {
  #  enable = true;
  #  configDir = ./home-manager/ags;
  #};

  #pywal-nix = {
  #  wallpaper = ./home-manager/extra_resources/Wallpaper.jpg;                  
  #};  

  systemd.user.startServices = "sd-switch";
  systemd.user.services = {
    battery = {
      Unit = {
        Description = "Battery Level Checker";
      };
      Service = {
        Restart="always";
        RestartSec=60;
        ExecStart="battery_listener.sh";
      };
    };
    battery_reset = {
      Unit = {
        Description = "Battery Level Checker Reset";
      };
      Service = {
        Restart="always";
        RestartSec=600;
        ExecStart="battery_reset.sh";
      };
    };
  };

  programs.home-manager.enable = true;
}