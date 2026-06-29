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
      wireplumber.enable = true; # Lua scripts removed; using defaults
      extraLadspaPackages = [ pkgs.rnnoise-plugin ];
      
      extraConfig.pipewire = {
        "filter-chain"."context.modules" = [
          
          { 
            name = "libpipewire-module-filter-chain";
            args = {
              "node.description" = "Noise Cancel (Mic)";
              "media.name"       = "Noise Cancel (Mic)";
              "filter.graph" = {
                nodes = [
                  { type   = "ladspa";
                    plugin = "librnnoise_ladspa";
                    label  = "noise_suppressor_mono";
                    name   = "rnnoise";
                  }
                ];
              };
              "capture.props" = {
                "node.name"    = "rnnoise_input";
                # Replaces Script 1: Tells PipeWire to auto-link this input to the default hardware microphone
                "node.passive" = true; 
              };
              "playback.props" = {
                "node.name"        = "rnnoise_output";
                "media.class"      = "Audio/Source";
                # Replaces Script 2: High priority forces WirePlumber to select this as the system default mic
                "priority.driver"  = 30000; 
                "priority.session" = 30000;
              };
            };
          }

          {
            name = "libpipewire-module-combine-stream";
            args = {
              "combine.mode" = "source";
              "node.name" = "combined_source";
              "node.description" = "Combined Mic + Desktop";
              "combine.props" = {
                "audio.position" = [ "FL" "FR" ];
                "media.class" = "Audio/Source";
              };
              "stream.rules" = [
                {
                  # Capture from the RNNoise microphone
                  matches = [ { "node.name" = "rnnoise_output"; } ];
                  actions = { "create-stream" = {}; };
                }
                {
                  # Capture from all desktop audio playback (Sink Monitors)
                  matches = [ { "media.class" = "Audio/Sink"; } ];
                  actions = { "create-stream" = {}; };
                }
              ];
            };
          }

        ];
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
  };
}