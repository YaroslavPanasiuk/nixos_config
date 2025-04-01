{ config, pkgs, inputs, ... }:

{ 
  programs.waybar = {
    enable = true;
    style = (builtins.readFile ./taskbar.css);
    settings = [
      {
        "layer" = "top";
        "position" = "bottom";
        "margin-top" = 3;
        "margin-bottom" = 3;
        "reload_style_on_change" = true;
        "height" = 60;
        modules-left = [];
        modules-center = [ "wlr/taskbar" ];
        modules-right = [];

        "wlr/taskbar" = {
            "format" = "{icon}";
            "max-length" = 15;
            "icon-size" = 50;
            "tooltip-format" = "{title}";
            "on-click" = "activate";
            "on-click-middle" = "close";
            "on-click-right" = "close";
        };
      }
    ];
  };
}