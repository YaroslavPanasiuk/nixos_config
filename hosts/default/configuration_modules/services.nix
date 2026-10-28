{ config, pkgs, lib, ... }:
let
  user = import ./user.nix;
in
{
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.defaultSopsFile = ../../../secrets/secrets.yaml;
  sops.secrets.postgres_password = {};

  services = {
    xserver = {
      enable = false;
      videoDrivers = [ "nvidia" ];
    };
    desktopManager.gnome.enable = true;

    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.extraConfig.bluetoothEnhancements = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" "a2dp_sink" "a2dp_source" ];
          "bluez5.auto-connect" = [ "a2dp_sink" ];
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
        CREATE ROLE yaroslav WITH LOGIN CREATEDB;
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
    flatpak.enable = true;
    gvfs.enable = true;
    gvfs.package = lib.mkForce pkgs.gnome.gvfs;
    tumbler.enable = true;
    spice-vdagentd.enable = true;
    openssh.enable = true;
    blueman.enable = true;
    #netbird.enable = true;
    #mullvad-vpn.enable = true;
  };

  # pg_hba above trusts local/loopback connections, so this can run as root without a password.
  systemd.services.postgresql-set-password = {
    after = [ "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      ${config.services.postgresql.package}/bin/psql -h 127.0.0.1 -U postgres -c \
        "ALTER ROLE yaroslav WITH PASSWORD '$(cat ${config.sops.secrets.postgres_password.path})'"
    '';
  };
}
