{ pkgs, lib, ... }:
let
  user = import ./user.nix;
in
{  
  services = {
    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "Hyprland >/dev/null 2>&1";
          user = "${user.name}";
        };
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          "hosts allow" = "192.168.31.220 192.168.31.231 192.168.122.53 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
        };
        "shared" = {
          "path" = "/home/${user.name}/Public";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "public" = "yes";
        };
      };
    };

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    udev.packages = [ pkgs.android-udev-rules ];

    dbus.enable = true;
    printing.enable = true;
    touchegg.enable = true;
    pulseaudio.enable = false;
    flatpak.enable = true;
    gvfs.enable = true;
    gvfs.package = lib.mkForce pkgs.gnome.gvfs;
    tumbler.enable = true;
    spice-vdagentd.enable = true;
    openssh.enable = true;
    blueman.enable = true;
    #stirling-pdf.enable = true;

  };
}