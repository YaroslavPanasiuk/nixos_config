{ inputs, ... }:
let
  user = import ../../configuration_modules/user.nix;
in
{
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];
  
  programs.hyprpanel = {
    enable = true;
    overlay.enable = true;
    hyprland.enable = true;
    overwrite.enable = true;
    layout = {
      "bar.layouts" = {
        "0" = {
          left = [ "dashboard" "systray" "windowtitle" "media" "cava" ];
          middle = [ "workspaces" ];
          right = [ "kbinput" "network" "bluetooth" "volume" "battery" "clock" "notifications" ];
        };
      }; 
    };
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
          leftClick = "set_layout.sh";
        };
        
        customModules.cava = {
          showActiveOnly = true;
          showIcon = false;
          bars = 10;
        };
        
        network = {
          truncation_size = 3;
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
          #show_icons = true;
          #workspaceMask = true;
          scroll_speed = 1;
          showAllActive = true;
          workspaces = 9;
        };
        media = {
          #show_label = false;
          show_active_only = true;
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
              directory1.command = "thunar";
              directory1.label = "󱂵 home";
              directory2.command = "thunar Downloads";
              directory2.label = "󰉍 Downloads";
              directory3.command = "thunar Documents";
              directory3.label = "󱧶 Documents";
            };
            right = {
              directory1.command = "thunar shared";
              directory1.label = "󰉏 shared";
              directory2.command = "thunar nixos";
              directory2.label = "󰚝 nixos";
              directory3.command = "thunar .config";
              directory3.label = "󰚝 .config";
            };
          };
          powermenu = {
            avatar.image = "~/Documents/logo.png";
            avatar.name = "${user.name}";
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
          lowBatteryNotification = false;

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
            opacity = 75;
            workspaces.fontSize = "1.4em";
            workspaces.pill.active_width = "10em";
            workspaces.pill.width = "4em";
            workspaces.pill.height = "4em";
            workspaces.pill.radius = "1.9rem * 0.6";
            workspaces.spacing = "1.2em";
            y_margins = "2px";

          };

          floating = false;
          layer = "bottom";
          margin_sides = "0";
          margin_top = "0";
          margin_bottom = "0";

          menus = {
            menu.clock.scaling = 90;
            menu.notifications.height = "40em";
          };
          opacity = 70;
          outer_spacing = "0";

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