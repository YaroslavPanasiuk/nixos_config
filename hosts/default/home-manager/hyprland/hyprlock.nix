{ config, pkgs, inputs, ... }:

{
  programs.hyprlock = {
    enable = true;

    settings = {
        source = [
            "~/.cache/wal/colors-hyprland.conf"
            "./greeting.conf"
        ];

        background = {
            monitor = "";
            path = "$HOME/Public/CurrentWallpaper/Background.png";
            blur_passes = 3;
            contrast = "0.8916";
            brightness = "0.8916";
            vibrancy = "0.8916";
            vibrancy_darkness = "0.0";
        };

        general = {
            no_fade_in = false;
            grace = 0;
            disable_loading_bar = false;
        };

        shape = {
            monitor = "";
            size = "500, 450";
            color = "rgba(0, 0, 0, 0.5)";
            rounding = 15;
            border_size = 0;
            rotate = 0;

            position = "0, -40";
            halign = "center";
            valign = "center";
        };

        image = {
            monitor = "";
            path = "$HOME/Documents/logo.png";
            border_size = 2;
            border_color = "$color1 $color2 45deg";
            size = 100;
            rounding = "-1";
            rotate = 0;
            reload_time = "-1";
            reload_cmd = "";
            position = "0, 185";
            halign = "center";
            valign = "center";
        };

        label = [
            {
                monitor = "";
                text = "    $USER";
                color = "$foreground";
                font_size = 16;
                font_family = "SF Pro Display Bold";
                position = "0, 95";
                halign = "center";
                valign = "center";
            }
            {
                monitor = "";
                text = ''cmd[update:1000] echo "<span>$(date +"%H:%M")</span>"'';
                color = "$foreground";
                font_size = 60;
                font_family = "SF Pro Display Bold";
                position = "0, 10";
                halign = "center";
                valign = "center";
            }
            {
                monitor = "";
                text = ''cmd[update:1000] echo -e "$(date +"%A, %d %B")"'';
                color = "rgba(216, 222, 233, .80)";
                font_size = 19;
                font_family = "SF Pro Display Bold";
                position = "0, -40";
                halign = "center";
                valign = "center";
            }
            {
                monitor = "";
                text = "$greeting";
                color = "$foreground";
                font_size = 20;
                font_family = "SF Pro Display Bold";
                position = "0, -110";
                halign = "center";
                valign = "center";
            }
        ];

        # INPUT FIELD
        input-field = {
            monitor = "";
            size = "320, 55";
            outline_thickness = 2;
            outer_color = "$color1 $color2 45deg";
            inner_color = "rgba(255, 255, 255, 0.1)";
            font_color = "$foreground";
            fade_on_empty = false;
            font_family = "SF Pro Display Bold";
            placeholder_text = ''<i><small><span font_weight="light" foreground="##ffffff99">Start typing ...</span></small></i>'';
            hide_input = false;
            position = "0, -183";
            halign = "center";
            valign = "center";
        };      
    };

  };

}