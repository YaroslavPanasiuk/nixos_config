{ config, pkgs, inputs, ... }:

{
  programs.rofi = {
	enable = true;
    configPath = "./colors-rofi.nix";
    extraConfig = {
        "*" = {
            active-background = "#9E251B";
            active-foreground = "@foreground";
            normal-background = "@background";
            normal-foreground = "@foreground";
            urgent-background = "#996038";
            urgent-foreground = "@foreground";

            alternate-active-background = "@background";
            alternate-active-foreground = "@foreground";
            alternate-normal-background = "@background";
            alternate-normal-foreground = "@foreground";
            alternate-urgent-background = "@background";
            alternate-urgent-foreground = "@foreground";

            selected-active-background = "#e2cdaa";
            selected-active-foreground = "@foreground";
            selected-normal-background = "#9E251B";
            selected-normal-foreground = "@foreground";
            selected-urgent-background = "#996038";
            selected-urgent-foreground = "@foreground";

            background-color = "@background";
            background = "#0E161C";
            foreground = "#e2cdaa";
            border-color = "@background";
            transparent-background = "#0E161C88" ;
            spacing = 2;
        };

        "#window" = {
            border = 0;
            padding = "2.5ch";
        };

        "#mainbox" = {
            border = 0;
            padding = 0;
        };

        "#message" = {
            border = "2px 0px 0px";
            border-color = "@border-color";
            padding = "1px";
        };

        "#textbox" = {
            text-color = "@foreground";
        };

        "#inputbar" = {
            children =   [ "prompt" "textbox-prompt-colon" "entry" "case-indicator" ];
        };

        "#textbox-prompt-colon" = {
            expand = false;
            str = ":";
            text-color = "@normal-foreground";
        };

        "#listview" = {
            fixed-height = 0;
            border = "2px 0px 0px";
            border-color = "@border-color";
            spacing = "2px";
            scrollbar = true;
            padding = "2px 0px 0px";
            background-color = "#0000";

        };

        "#element" = {
            border = 0;
            padding = "1px";
        };

        "#element.normal.normal" = {
            background-color = "#0000";
            text-color = "@normal-foreground";
        };

        "#element.normal.urgent" = {
            background-color = "#0000";
            text-color = "@urgent-foreground";
        };

        "#element.normal.active" = {
            background-color = "#0000";
            text-color = "@active-foreground";
        };

        "#element.selected.normal" = {
            background-color = "@selected-normal-background";
            text-color = "@selected-normal-foreground";
        };

        "#element.selected.urgent" = {
            background-color = "@selected-urgent-background";
            text-color = "@selected-urgent-foreground";
        };

        "#element.selected.active" = {
            background-color = "@selected-active-background";
            text-color = "@selected-active-foreground";
        };

        "#element.alternate.normal" = {
            background-color = "#0000";
            text-color = "@alternate-normal-foreground";
        };

        "#element.alternate.urgent" = {
            background-color = "#0000";
            text-color = "@alternate-urgent-foreground";
        };

        "#element.alternate.active" = {
            background-color = "#0000";
            text-color = "@alternate-active-foreground";
        };

        "#scrollbar" = {
            width = "0px";
            border = 0;
            handle-width = "0px";
            padding = 0;
        };

        "#sidebar" = {
            border = "2px 0px 0px";
            border-color = "@border-color";
        };

        "#button" = {
            text-color = "@normal-foreground";
        };

        "#button.selected" = {
            background-color = "@selected-normal-background";
            text-color = "@selected-normal-foreground";
        };

        "#inputbar" = {
            spacing = 0;
            text-color = "@normal-foreground";
            padding = "1px";
        };

        "#case-indicator" = {
            spacing = 0;
            text-color = "@normal-foreground";
        };

        "#entry" = {
            spacing = 0;
            text-color = "@normal-foreground";
        };

        "#prompt" = {
            spacing = 0;
            text-color = "@normal-foreground";
        };

    };
  };
}