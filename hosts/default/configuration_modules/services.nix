{ pkgs, lib, ... }:
let
  user = import ./user.nix;
in
{  
  services = {
    xserver = {
      enable = false;
      videoDrivers = [ "nvidia" ];
    };
    desktopManager.gnome.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber = {
        enable = true;
        extraConfig.bluetoothEnhancements = {
          "10-soundcore-a2dp" = {
            "monitor.bluez.rules" = [
              {
                matches = [
                  { "device.name" = "~bluez_card.*F4_2B_7D_64_02_17"; }
                ];
                actions = {
                  update-props = {
                    "bluez5.auto-connect" = [ "a2dp_sink" ];
                    "bluez5.hw-volume" = [ ];
                  };
                };
              }
            ];
          };
        };
      };
    };


    greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "start-hyprland";
          user = "${user.name}";
        };
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd Hyprland";
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
          "hosts allow" = "192.168.31.220 192.168.31.231 192.168.122.53 192.168.122.100 127.0.0.1 192.168.31.71 localhost";
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

    postgresql = {
      enable = true;
      ensureDatabases = [ "nova_bot" ];
      enableTCPIP = true;
      settings.port = 5432;
      authentication = pkgs.lib.mkOverride 10 ''
        local all      all     trust
        host  all      all     127.0.0.1/32   trust
        host  all      all     ::1/128        trust
      '';
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE yaroslav WITH LOGIN PASSWORD '1246' CREATEDB;
        CREATE DATABASE nova_bot;
        GRANT ALL PRIVILEGES ON DATABASE nova_bot TO yaroslav;
      '';
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    printing = {
      enable = true;
    };

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    udev.extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="video", MODE="0660"
    '';

    dbus.enable = true;
    dbus.implementation = "broker";
    touchegg.enable = true;
    pulseaudio.enable = false;
    flatpak.enable = true;
    gvfs.enable = true;
    gvfs.package = lib.mkForce pkgs.gnome.gvfs;
    tumbler.enable = true;
    spice-vdagentd.enable = true;
    openssh.enable = true;
    blueman.enable = true;
    #netbird.enable = true;
    mullvad-vpn.enable = true;
  };
}