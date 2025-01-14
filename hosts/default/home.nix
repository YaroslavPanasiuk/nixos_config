{ config, pkgs, inputs, ... }:

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
      #hyprpanel
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
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    battery_reset = {
      Unit = {
        Description = "Battery service resetter";
      };
      Service = {
        Restart="always";
        RestartSec=1200;
        ExecStart="battery_reset.sh";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };

  programs.home-manager.enable = true;
}