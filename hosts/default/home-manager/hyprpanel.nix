# *.nix
{ inputs, ... }:
{
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];
  
  programs.hyprpanel = {

    # Enable the module.
    # Default: false
    enable = true;

    # Automatically restart HyprPanel with systemd.
    # Useful when updating your config so that you
    # don't need to manually restart it.
    # Default: false
    systemd.enable = true;

    # Add '/nix/store/.../hyprpanel' to the
    # 'exec-once' in your Hyprland config.
    # Default: false
    hyprland.enable = true;

    # Fix the overwrite issue with HyprPanel.
    # See below for more information.
    # Default: false
    overwrite.enable = true;

    # Import a specific theme from './themes/*.json'.
    # Default: ""
    #theme = "/home/yaros/.cache/wal/";

    # Configure bar layouts for monitors.
    # See 'https://hyprpanel.com/configuration/panel.html'.
    # Default: null
    layout = {
      "bar.layouts" = {
        "0" = {
          left = [ "dashboard" "windowtitle" "media" ];
          middle = [ "workspaces" ];
          right = [ "systray" "kbinput" "network" "bluetooth" "volume" "clock" "battery" "notifications" ];
        };
      }; 
    };

    # Configure and theme *most* of the options from the GUI.
    # See './nix/module.nix:103'.
    # Default: <same as gui>
    settings = {
      bar = {
        launcher = {
          autoDetectIcon = true;
          rightClick = "wallpaper_change.sh";
        };
        clock = {
          format = "%A, %d %B %H:%M:%S";
          rightClick = "gnome-clocks";
        };
        battery = {
          rightClick = "gnome-power-statistics";
        };
        bluetooth = {
          label = false;
          rightClick = "rfkill toggle bluetooth";
        };
        customModules.kbLayout = {
          leftClick = "layout_msg.sh";
        };
        network = {
          truncation_size = 4;
          rightClick = "toggle_wifi.sh";
        };
        notifications = {
          hideCountWhenZero = true;
        };
        volume = {
          scrollDown = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
          scrollUp = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
        };
        windowtitle = {
          rightClick = "hyprctl dispatch killactive";
        };
        workspaces = {
          show_icons = true;
          workspaces = 10;
        };


      };

      menus = {
        clock = {
          time = {
            military = true;
          };
          weather = {
            unit = "metric";
            key = "811bf3d5620844dd9a4205412242612";
            location = "49.834987451354586,23.997110811101745";
          };
        };
        dashboard = {
          directories = {
            left = {
              directory1.command = "thunar ~/";
              directory1.label = "󱂵 yaros";
              directory2.command = "thunar ~/Downloads";
              directory2.label = "󰉍 Downloads";
              directory3.command = "thunar ~/Documents";
              directory3.label = "󱧶 Documents";
            };
            right = {
              directory1.command = "thunar ~/shared";
              directory1.label = "󰉏 shared";
              directory2.command = "thunar ~/nixos";
              directory2.label = "󰚝 nixos";
              directory3.command = "thunar ~/.config";
              directory3.label = "󰚝 .config";
            };
          };
          powermenu = {
            avatar.image = "~/Documents/biceps016.jpg";
            avatar.name = "Panas";
          };
          shortcuts.enabled = false;
          stats.interval = 5000;
        };
        media = {
          displayTime = true;
          displayTimeTooltip = true;
          noMediaText = "No Media Currently Playing 󰱭";
        };
        power = {
          lowBatteryNotification = true;

        };

      };

      notifications = {
        clearDelay = 10;
        displayedTotal = 15;
      };

      scalingPriority = "hyprland";

      wallpaper = {
        enable = false;
      };

      theme = {
        bar = {
          buttons = {
            opacity = 85;
            workspaces.fontSize = "1.4em";
            workspaces.pill.active_width = "8em";
            workspaces.spacing = "0.8em";
            y_margins = "0";
          };

          floating = true;
          layer = "bottom";
          margin_sides = "0px";
          margin_top = "0.3em";
          margin_bottom = "0.1em";

          menus = {
            menu.clock.scaling = 90;
            menu.notifications.height = "40em";
          };
          opacity = 30;
          outer_spacing = "0.3em";

        };

        font = {
          name = "CaskaydiaCove NF";
          size = "15px";
          weight = 600;
        };

        osd = {
          scaling = 120;
          margins = "0px 8px 0px 0px";
        };
        #matugen = true;
      };
    };
  };
}