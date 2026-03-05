{ config, pkgs, inputs, ... }:

{ 
  programs.waybar = {
    enable = true;
    style = (builtins.readFile ./waybar.css);
    settings = [{
      height = 26;
      layer = "bottom";
      "output" = "eDP-1";
      margin-top = 0;
      position = "top";
      reload_style_on_change = true;
      spacing = 5;
      
      "backlight#1" = {
        device = "intel_backlight";
        format = "<span size='large'>{icon}</span>";
        format-icons = [
          "󰃞 "
          "󰃞 "
          "󰃟 "
          "󰃝 "
          "󰃠 "
        ];
        on-click = "redshift.sh";
        on-scroll-down = "brightness.sh up 2";
        on-scroll-up = "brightness.sh down 2";
        tooltip-format = "Brigthness {percent}%";
      };
      
      "backlight#2" = {
        device = "intel_backlight";
        format = "<span size='small'>{percent}%</span>";
        on-click = "redshift.sh";
        on-scroll-down = "brightness.sh up 2";
        on-scroll-up = "brightness.sh down 2";
        tooltip-format = "Brigthness {percent}%";
      };
      
      "backlight/slider" = {
        device = "intel_backlight";
        max = 100;
        min = 0;
        orientation = "horizontal";
      };
      
      "battery#1" = {
        format = "<span size='large'>{icon}</span>";
        format-charging = "<span size='medium'></span> ";
        format-full = "<span size='large'>{icon}</span>";
        format-good = "<span size='large'>{icon}</span>";
        format-icons = [
          " "
          " "
          " "
          " "
          " "
        ];
        format-plugged = "<span size='medium'></span>";
        interval = 1;
        on-click-right = "gnome-power-statistics";
        states = {
          critical = 15;
          good = 95;
          warning = 30;
        };
      };
      
      "battery#2" = {
        format = "<span size='small'>{capacity}%</span>";
        interval = 30;
        on-click-right = "gnome-power-statistics";
      };
      
      cava = {
        autosens = 1;
        bar_delimiter = 0;
        bars = 7;
        format-icons = [
          "▁"
          "▂"
          "▃"
          "▄"
          "▅"
          "▆"
          "▇"
          "█"
        ];
        framerate = 60;
        hide_on_silence = true;
        higher_cutoff_freq = 18000;
        input_delay = 2;
        lower_cutoff_freq = 50;
        method = "pulse";
        monstercat = false;
        noise_reduction = 0.35;
        on-click-right = "playerctl pause";
        reverse = false;
        sleep_timer = 1;
        source = "auto";
        stereo = false;
        waves = true;
      };
      
      "clock#1" = {
        calendar = {
          format = {
            days = "<span color='#aaa'><b>{}</b></span>";
            months = "<span color='#fff'><b>{}</b></span>";
            today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            weekdays = "<span color='#ccc'><b>{}</b></span>";
          };
          mode = "month";
          "mode-mon-col" = 3;
          "on-scroll" = 1;
        };
        format = "{:L%A, %e %B}";
        on-click = "morgen";
        tooltip-format = "<tt>{calendar}</tt>";
      };
      
      "clock#2" = {
        format = "{:%d.%m}";
        on-click = "~/.config/waybar/open_calendar.sh";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };
      
      "clock#3" = {
        format = "{:%H:%M:%S}";
        interval = 1;
        tooltip-format = "{:%H:%M:%S (%Z)}";
      };

      "clock#4" = {
        "format" = " Universal: {:%H:%M} ";
        "timezone" = "Etc/UTC";
        "interval" = 60;
        "tooltip-format" = "{:%H:%M (%Z)}";
      };
      "clock#5" = {
        "format" = " Seattle: {:%H:%M} ";
        "timezone" = "America/Los_Angeles";
        "interval" = 60;
        "tooltip-format" = "{:%H:%M (%Z)}";
      };
      
      cpu = {
        format = "<span > </span><span size='small'>{usage}% {icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}</span>";
        format-icons = [
          "<span color='#00FF00'>▁</span>"
          "<span color='#80FF00'>▂</span>"
          "<span color='#BFFF00'>▃</span>"
          "<span color='#FFFF00'>▄</span>"
          "<span color='#FFBF00'>▅</span>"
          "<span color='#FF8000'>▆</span>"
          "<span color='#FF4000'>▇</span>"
          "<span color='#FF0000'>█</span>"
        ];
        on-click = "gnome-system-monitor -r";
        tooltip-format = "{load}";
      };
      
      "custom/android" = {
        format = "";
        on-click = "start_waydroid.sh";
        on-click-right = "stop_waydroid.sh";
        tooltip = false;
      };
      
      "custom/macos" = {
        format = "";
        on-click = "start_macos.sh ";
        on-click-right = "pkill qemu";
        tooltip = false;
      };
      
      "custom/separator" = {
        format = "|";
        tooltip = false;
      };
      
      "custom/timer" = {
        exec = "waybar_timer.sh check";
        interval = 1;
        on-click = "waybar_timer.sh minute_dialog";
        on-click-right = "waybar_timer.sh stop";
        return-type = "json";
        tooltip = true;
      };
      
      "custom/wallpaper_change" = {
        format = "󰸉";
        on-click = "wallpaper_change.sh";
        on-click-right = "wallp-rofi.sh";
        tooltip = false;
      };
      
      "custom/weather#1" = {
      "exec" = "fetch_weather.sh --hours 18 --height 6 --refresh 900";
        format = "{}";
        signal = 101;
        "restart-interval" = "1";
        return-type = "json";
        tooltip = true;
      };
      
      "custom/weather#2" = {
      "exec" = "fetch_weather.sh --hours 18 --height 6 --refresh 900 --city Drohobych";
        format = "Дрогобич {}";
        signal = 101;
        "restart-interval" = "1";
        return-type = "json";
        tooltip = true;
      };

      
      "custom/windows" = {
        format = "󰖳";
        on-click = "start_windows.sh";
        on-click-right = "stop_windows.sh";
        tooltip = false;
      };
      
      disk = {
        format = " <span size='small'>{percentage_used}%</span>";
        interval = 30;
        on-click = "gnome-system-monitor -f";
        on-click-right = "baobab";
        path = "/";
        tooltip-format = "{specific_free} GB left";
        unit = "GB";
      };
      
      "group/audio" = {
        drawer = {
          "transition-duration" = 500;
          "transition-left-to-right" = false;
        };
        modules = [
          "pulseaudio#1"
          "pulseaudio/slider"
          "pulseaudio#2"
        ];
        orientation = "horizontal";
      };

      "group/weather" = {
        drawer = {
          "click-to-reveal" = true;
          "transition-duration" = 500;
          "transition-left-to-right" = false;
        };
        modules = [
          "custom/weather#1"
          "custom/weather#2"
        ];
        orientation = "horizontal";
      };
      
      "group/battery_group" = {
        drawer = {
          "click-to-reveal" = false;
          "transition-duration" = 500;
          "transition-left-to-right" = false;
        };
        modules = [
          "battery#1"
          "battery#2"
        ];
        orientation = "horizontal";
      };
      
      "group/brightness" = {
        drawer = {
          "transition-duration" = 500;
          "transition-left-to-right" = false;
        };
        modules = [
          "backlight#1"
          "backlight/slider"
          "backlight#2"
        ];
        orientation = "horizontal";
      };
      
      "group/power" = {
        drawer = {
          "click-to-reveal" = false;
          "transition-duration" = 500;
          "transition-left-to-right" = false;
        };
        modules = [
          "power-profiles-daemon"
          "custom/separator"
          "cpu"
          "custom/separator"
          "memory"
          "custom/separator"
          "disk"
        ];
        orientation = "horizontal";
      };
      
      "group/time" = {
        drawer = {
          "click-to-reveal" = true;
          "transition-duration" = 500;
          "transition-left-to-right" = true;
        };
        modules = [
          "clock#3"
          "custom/separator"
          "clock#4"
          "custom/separator"
          "clock#5"
          "custom/timer"
        ];
        orientation = "horizontal";
      };
      
      "hyprland/language" = {
        "format-en" = "<span size='small'>EN </span>🇺🇸";
        "format-uk" = "<span size='small'>UA </span>🇺🇦";
        keyboard-name = "at-translated-set-2-keyboard";
        on-click = "set_layout.sh";
      };
      
      "custom/language" = {
        exec = "waybar_language.sh";
        format = "{}";
        on-click = "set_layout.sh";
        return-type = "json";
        tooltip = true;
      };
      
      "hyprland/window" = {
        format = "{title:.25}";
        tooltip = false;
        icon = true;
        icon-size = 17;
        rewrite = {
          "" = "<span size='large'></span> NixOs";
        };
        separate-outputs = true;
      };
      
      "hyprland/workspaces" = {
        format = "{icon}";
        signal = 8;
        format-icons = {
          active = "<span size='small'>󰪥</span>";
          default = "<span size='small'>󰺕</span>";
          empty = "<span size='small'>󰄰</span>";
        };
      };
      
      memory = {
        format = " <span size='small'>{}% </span>";
        on-click = "gnome-system-monitor -r";
        tooltip-format = "{used} GB/{total} GB; Swap: {swapAvail} GB";
      };
      
      modules-center = [
        "clock#1"
        "hyprland/workspaces"
        "group/time"
      ];
      
      modules-left = [
        "custom/wallpaper_change"
        "hyprland/window"
        "wlr/taskbar"
        "mpris"
      ];
      
      modules-right = [
        "tray"
        "custom/language"
        "group/weather"
        "group/audio"
        "cava"
        "group/brightness"
        "group/battery_group"
        "group/power"
      ];
      
      mpris = {
        format = "{player_icon} <span size='small'><i>{title:.20}</i></span> ";
        format-paused = "{player_icon} <span size='small'><i>{title:.20}</i></span> ";
        player-icons = {
          chromium = "";
          firefox = "";
          mpv = "";
          vlc = "󰕼";
        };
      };
      
      "power-profiles-daemon" = {
        format = "{icon}";
        format-icons = {
          balanced = "";
          default = "";
          performance = "";
          "power-saver" = "󰌪";
        };
        interval = 18;
        tooltip = true;
        tooltip-format = "Power profile: {profile}\nDriver: {driver}";
      };
      
      "pulseaudio#1" = {
        format = "<span size='large'>{icon}</span>";
        format-bluetooth = "{icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-icons = {
          car = " ";
          default = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
          "hands-free" = " ";
          headphone = "󰋋 ";
          headset = " ";
          phone = " ";
          portable = " ";
        };
        format-muted = "<span >󰖁</span>";
        format-source = "";
        format-source-muted = " ";
        on-click = "pavucontrol";
        on-click-right = "volume.sh mute";
        on-scroll-down = "volume.sh up 2";
        on-scroll-up = "volume.sh down 2";
      };
      
      "pulseaudio#2" = {
        format = "<span size='small'>{volume}%</span>";
        format-bluetooth = "{volume}%";
        format-bluetooth-muted = "";
        format-muted = "<span size='small'>{volume}%</span>";
        format-source = "{volume}%";
        format-source-muted = "";
        on-click = "pavucontrol";
        on-click-right = "volume.sh mute";
        on-scroll-down = "volume.sh up 2";
        on-scroll-up = "volume.sh down 2";
      };
      
      "pulseaudio/slider" = {
        max = 100;
        min = 0;
        orientation = "horizontal";
      };
      
      temperature = {
        format = "<span size='large'>{icon}</span> <span size='small'>{temperatureC}°C</span>";
        format-icons = [
          ""
          ""
          ""
        ];
        on-click = "gnome-system-monitor";
      };
      
      tray = {
        icon-size = 17;
        spacing = 6;
      };
      
      "wlr/taskbar" = {
        all-outputs = true;
        format = "{icon}";
        icon-size = 16;
        ignore-list = [ "kitty" ];
        "max-length" = 15;
        on-click = "activate";
        "on-click-middle" = "close";
        "on-click-right" = "close";
        tooltip-format = "{title}";
      };
    }];
  };
}