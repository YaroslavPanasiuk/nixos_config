{ config, pkgs, inputs, ... }:

{ 
  programs.waybar = {
    enable = true;
    style = (builtins.readFile ./waybar.css);
    settings = [{
      "backlight#1"= {
        "device"= "intel_backlight";
        "format"= "<span size='large'>{icon}</span>";
        "format-icons"= [
          "󰃞 "
          "󰃞 "
          "󰃟 "
          "󰃝 "
          "󰃠 "
        ];
        "on-click"= "redshift.sh";
        "tooltip-format"= "Brigthness {percent}%";
        "on-scroll-up"= "brightness.sh down 2";
        "on-scroll-down"= "brightness.sh up 2";
      };
      "backlight#2"= {
        "device"= "intel_backlight";
        "format"= "<span size='small'>{percent}%</span>";
        "on-click"= "redshift.sh";
        "tooltip-format"= "Brigthness {percent}%";
        "on-scroll-up"= "brightness.sh down 2";
        "on-scroll-down"= "brightness.sh up 2";
      };
      "battery#1"= {
        "format"= "<span size='large'>{icon}</span>";
        "format-charging"= "<span size='medium'></span> ";
        "format-full"= "<span size='large'>{icon}</span>";
        "format-good"= "<span size='large'>{icon}</span>";
        "format-icons"= [
          " "
          " "
          " "
          " "
          " "
        ];
        "format-plugged"= "<span size='medium'></span>";
        "interval"= 1;
        "on-click-right"= "gnome-power-statistics";
        "states"= {
          "critical"= 15;
          "good"= 95;
          "warning"= 30;
        };
      };
      "battery#2"= {
        "format"= "<span size='small'>{capacity}%</span>";
        "interval"= 10;
        "on-click-right"= "gnome-power-statistics";
      };
      "clock#1"= {
        "format"= "{:L%A, %e %B}";
        "on-click"= "obsidian";
        "tooltip-format"= "<tt>{calendar}</tt>";
        "calendar"= {
          "mode"          = "month";
          "mode-mon-col"  = 3;
          "weeks-pos"     = "right";
          "on-scroll"     = 1;
          "format"= {
            "months"=     "<span color='#fff'><b>{}</b></span>";
            "days"=       "<span color='#aaa'><b>{}</b></span>";
            "weekdays"=   "<span color='#ccc'><b>{}</b></span>";
            "today"=      "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
        };
      };
      "clock#2"= {
        "format"= "{:%d.%m}";
        "on-click"= "~/.config/waybar/open_calendar.sh";
        "tooltip-format"= "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };
      "clock#3"= {
        "format"= "{:%H:%M:%S}";
        "interval"= 1;
        "on-click"= "gnome-clocks";
        "tooltip-format"= "{tz_list}";
        "timezones"= [
          "Europe/Kyiv"
          "Etc/UTC"
          "US/Pacific"
        ];
      };
      "cpu"= {
        "format"= "<span > </span><span size='small'>{usage}% {icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}</span>";
        "format-icons"= [
          "<span color='#00FF00'>▁</span>" 
          "<span color='#80FF00'>▂</span>" 
          "<span color='#BFFF00'>▃</span>" 
          "<span color='#FFFF00'>▄</span>" 
          "<span color='#FFBF00'>▅</span>" 
          "<span color='#FF8000'>▆</span>" 
          "<span color='#FF4000'>▇</span>" 
          "<span color='#FF0000'>█</span>" 
        ];
        "on-click"= "gnome-system-monitor";
        "tooltip-format"= "{load}";
      };
      "custom/android"= {
        "format"= "";
        "on-click"= "start_waydroid.sh";
        "on-click-right"= "stop_waydroid.sh";
        "tooltip"= false;
      };
      "custom/macos"= {
        "format"= "";
        "on-click"= "start_macos.sh ";
        "on-click-right"= "pkill qemu";
        "tooltip"= false;
      };
      "custom/separator"= {
        "format"= "|";
        "tooltip"= false;
      };
      "custom/wallpaper_change"= {
        "format"= "󰸉";
        "on-click"= "wallpaper_change.sh";
        "on-click-right"= "wallp-rofi.sh";
        "tooltip"= false;
      };
      "custom/windows"= {
        "format"= "󰖳";
        "on-click"= "start_windows.sh";
        "on-click-right"= "stop_windows.sh";
        "tooltip"= false;
      };
      "height"= 26;
      "hyprland/language"= {
        "format-en"= "<span size='small'>EN </span>🇺🇸";
        "format-uk"= "<span size='small'>UA </span>🇺🇦";
        "on-click"= "set_layout.sh";
      };
      "hyprland/workspaces"= {
        "format"= "{icon}";
        "format-icons"= {
          "urgent"= "🞉";
          "active"= "🞊";
          "default"= "🞆";
        };
      };
      "layer"= "bottom";
      "margin-top"= 0;
      "memory"= {
        "format"= " <span size='small'>{}% </span>";
        "on-click"= "gnome-system-monitor";
        "tooltip-format"= "{used} GB/{total} GB; Swap: {swapAvail} GB";
      };
      "disk"= {
        "interval"= 30;
        "format"= " <span size='small'>{percentage_used}%</span>";
        "tooltip-format"= "{specific_used} GB/{specific_total} GB";
        "unit"= "GB";
        "path"= "/";
      };

      "modules-center"= [
        "clock#1"
        
        "hyprland/workspaces"
        
        "clock#3"
      ];
      "modules-left"= [
        "custom/wallpaper_change"
        "hyprland/window"
        
        "wlr/taskbar"
        
        "mpris"
      ];
      "modules-right"= [
        "tray"
        "hyprland/language"
        "custom/weather"
        "group/audio"
        "cava"
        "group/brightness"
        "group/power"
        "power-profiles-daemon"
      ];
      "position"= "top";
      "power-profiles-daemon"= {
        "format"= "{icon}";
        "format-icons"= {
          "balanced"= "";
          "default"= "";
          "performance"= "";
          "power-saver"= "󰌪";
        };
        "interval"= 10;
        "tooltip"= true;
        "tooltip-format"= "Power profile: {profile}\nDriver: {driver}";
      };
      "pulseaudio#1"= {
        "format"= "<span size='large'>{icon}</span>";
        "format-bluetooth"= "{icon} {format_source}";
        "format-bluetooth-muted"= " {icon} {format_source}";
        "format-icons"= {
          "car"= " ";
          "default"= [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
          "hands-free"= " ";
          "headphone"= "󰋋 ";
          "headset"= " ";
          "phone"= " ";
          "portable"= " ";
        };

        "format-muted"= "<span >󰖁</span>";
        "format-source"= "";
        "format-source-muted"= " ";
        "on-click"= "pavucontrol";
        "on-click-right"= "volume.sh mute";
        "on-scroll-up"= "volume.sh down 2";
        "on-scroll-down"= "volume.sh up 2";
      };

      "pulseaudio#2"= {
        "format"= "<span size='small'>{volume}%</span>";
        "format-bluetooth"= "{volume}%";
        "format-bluetooth-muted"= "";
        "format-muted"= "<span size='small'>{volume}%</span>";
        "format-source"= "{volume}%";
        "format-source-muted"= "";
        "on-click"= "pavucontrol";
        "on-click-right"= "volume.sh mute";
        "on-scroll-up"= "volume.sh down 2";
        "on-scroll-down"= "volume.sh up 2";
      };
      "reload_style_on_change"= true;
      "spacing"= 5;
      "temperature"= {
        "format"= "<span size='large'>{icon}</span> <span size='small'>{temperatureC}°C</span>";
        "format-icons"= [
          ""
          ""
          ""
        ];
        "on-click"= "gnome-system-monitor";
      };
      "tray"= {
        "icon-size"= 20;
        "spacing"= 6;
      };
      "wlr/taskbar"= {
        "format"= "{icon}";
        "icon-size"= 20;
        "max-length"= 15;
        "ignore-list"= [
          "kitty"
        ];
        "on-click"= "activate";
        "on-click-middle"= "close";
        "on-click-right"= "close";
        "tooltip-format"= "{title}";
      };
      "cava"= {
          "framerate"= 60;
          "autosens"= 1;
          "bars"= 7;
          "lower_cutoff_freq"= 50;
          "higher_cutoff_freq"= 10000;
          "hide_on_silence"= true;
          "method"= "pulse";
          "source"= "auto";
          "stereo"= false;
          "reverse"= false;
          "bar_delimiter"= 0;
          "monstercat"= false;
          "waves"= true;
          "noise_reduction"= 0.35;
          "input_delay"= 2;
          "format-icons" = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
          "on-click-right" = "playerctl pause";
      };
      "pulseaudio/slider"= {
        "min"= 0;
        "max"= 100;
        "orientation"= "horizontal";
      };
      "backlight/slider"= {
        "device"= "intel_backlight";
        "min"= 0;
        "max"= 100;
        "orientation"= "horizontal";
      };
      "hyprland/window"= {
        "format"= "{title:.15}";
        "icon"= true;
        "icon-size"= 20;
        "separate-outputs"= true;
      };
      "mpris"= {
        "format"= "{player_icon} <span size='small'><i>{title:.15}</i></span> ";
        "format-paused"= "{player_icon} <span size='small'><i>{title:.15}</i></span> ";
        "player-icons"= {
          "chromium"= "";
          "mpv"= "";
          "vlc"= "󰕼";
          "firefox"= "";
        };
      };
      "custom/weather"= {
          "format"= "<span size='small'>{}°</span>";
          "tooltip"= true;
          "interval"= 3600;
          "exec"= "wttrbar";
          "return-type"= "json";
      };
      "group/audio"= {
        "orientation"= "horizontal";
        "drawer"= {
          "transition-duration"= 500;
          "transition-left-to-right"= false;
        };
        "modules"= [
          "pulseaudio#1"
          "pulseaudio/slider"
          "pulseaudio#2"
        ];
      };
      "group/brightness"= {
        "orientation"= "horizontal";
        "drawer"= {
          "transition-duration"= 500;
          "transition-left-to-right"= false;
        };
        "modules"= [
          "backlight#1"
          "backlight/slider"
          "backlight#2"
        ];
      };
      "group/power"= {
        "orientation"= "horizontal";
        "drawer"= {
          "transition-duration"= 500;
          "click-to-reveal"= false;
          "transition-left-to-right"= false;
        };
        "modules"= [
          "battery#1"
          "custom/separator"
          "cpu"
          "custom/separator"
          "memory"
          "custom/separator"
          "disk"
          "custom/separator"
          "battery#2"
        ];
      };
    }];
  };
}