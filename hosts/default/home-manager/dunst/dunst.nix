{ config, pkgs, inputs, ... }:

{
  services.dunst = {
    enable = true;
    #configFile = "./dunstrc";
    settings = {
      global = {
        enable_posix_regex = true;
        width = 400;
        height = 300;
        notification_limit = 6;
        offset = "0x3";
        padding = 15;
        horizontal_padding = 15;
        text_icon_padding = 5;
        frame_width = 2;
        separator_color = "auto";
        sort = "update";
        progress_bar_horizontal_alignment = "center";
        progress_bar_min_width = 350;
        progress_bar_max_width = 380;
        progress_bar_corner_radius = 3;
        progress_bar_height = 7;
        font = "CaskaydiaCove Nerd Font Mono 11";
        format = "%a\n  <b>%s</b>\n%b\n%p";
        history_length = 100;
        browser = "${config.programs.firefox.package}/bin/firefox -new-tab";
        corner_radius = 8;
        corners = ["bottom-right" "bottom-left" "top-left"];
        mouse_left_click="close_current";
        mouse_right_click="close_all";
        mouse_middle_click="close_all";
        vertical_alignment = "top";
        gap_size = 3;
      };
      low_urgency = {
        background = "${config.pywal-nix.colourScheme.special.background}d0";
        foreground = "${config.pywal-nix.colourScheme.special.foreground}";
        frame_color = "${config.pywal-nix.colourScheme.colours.colour1}";
        set_stack_tag = "ulow";
        timeout = 4;
      };

      urgency_normal = {
        background = "${config.pywal-nix.colourScheme.special.background}d0";
        foreground = "${config.pywal-nix.colourScheme.special.foreground}";
        frame_color = "${config.pywal-nix.colourScheme.colours.colour1}";
        timeout = 5;
      };

      urgency_critical = {
        background = "6e0404";
        foreground = "${config.pywal-nix.colourScheme.special.foreground}";
        frame_color = "${config.pywal-nix.colourScheme.colours.colour1}";
        timeout = 0;
      };

      volume = {
        appname = "volume_notification";
        summary = "volume";
        max_icon_size = 24;
        min_icon_size = 24;
        highlight = "${config.pywal-nix.colourScheme.colours.colour14}";
        format = "  %b%n%%";
        word_wrap = false;
        timeout = 1;
      };

      muted = {        
        appname = "volume_notification";
        summary = "muted";
        max_icon_size = 24;
        min_icon_size = 24;
        format = "  %b";
        timeout = 1;
        padding = 5;
      };

      battery = {
        appname = "Low battery";
        max_icon_size = 24;
        min_icon_size = 24;
        format = "  %b";
      };
    };
  };
}