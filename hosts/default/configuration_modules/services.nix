{ pkgs, lib, ... }:
let
  user = import ./user.nix;
in
{  
  services = {
    xserver = {
      enable = false;
    };
    desktopManager.gnome.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
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
                    plugin = "/run/current-system/sw/lib/ladspa/librnnoise_ladspa.so";
                    label  = "noise_suppressor_mono";
                    name   = "rnnoise";
                  }
                ];
              };
              "capture.props" = {
                "node.name"      = "rnnoise_input";
              };

              "playback.props" = {
                "node.name"   = "rnnoise_output";
                "media.class" = "Audio/Source";  # mark the output as a microphone
              };
            };
          }
        ];
      };
      wireplumber = {
        enable = true;

        extraScripts = {
          "50-noise-cancel.lua" = ''
            Core.onObjectAdded({"node"}, function (node)
              local name = node.properties["node.name"] or ""
              if name == "rnnoise_input" then
                local mic = nil
                for n in Node("media.class=Audio/Source").iter() do
                  if n.properties["node.name"] ~= "rnnoise_output" then
                    mic = n
                    break
                  end
                end
                if mic then
                  Log.info("Auto-linking mic " .. mic.properties["node.name"] .. " → rnnoise_input")
                  Link { output = mic, input = node }:activate(Features.ALL)
                end
              end
            end)
          '';

          "60-set-default-noise-cancel.lua" = ''
            Core.onObjectAdded({"node"}, function(node)
              local name = node.properties["node.name"] or ""
              local mediaClass = node.properties["media.class"] or ""
              if name == "rnnoise_output" and mediaClass == "Audio/Source" then
                Log.info("Setting rnnoise_output as default input")
                Core.defaultInputNode = node
              end
            end)
          '';

          "70-combined-source.lua" = ''
            Core.onStartup(function()
                local default_sink_name = Core.getDefaultNode("Audio/Sink")
                if not default_sink_name then
                    Log.warn("No default sink found")
                    return
                end

                local sources = {
                    "rnnoise_output",
                    default_sink_name .. ".monitor"
                }

                Log.info("Creating combined source with: " .. table.concat(sources, ", "))

                Node.create({
                    type = "adapter",
                    media_class = "Audio/Source",
                    node_name = "combined_source",
                    nodes = sources
                })
            end)
          '';
        };

        # remove extraConfig for components/profiles
      };
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
          "hosts allow" = "192.168.31.220 192.168.31.231 192.168.122.53 192.168.122.100 127.0.0.1 localhost";
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

    udev.packages = [ pkgs.android-udev-rules ];

    dbus.enable = true;
    touchegg.enable = true;
    pulseaudio.enable = false;
    flatpak.enable = true;
    gvfs.enable = true;
    gvfs.package = lib.mkForce pkgs.gnome.gvfs;
    tumbler.enable = true;
    spice-vdagentd.enable = true;
    openssh.enable = true;
    blueman.enable = true;
    teamviewer.enable = true;
    #tailscale.enable = true;
    netbird.enable = true;
    #stirling-pdf.enable = true;
  };
}