{ config, pkgs, inputs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true; 
    systemd.variables = ["--all"];

    plugins = [
      inputs.hyprtasking.packages.${pkgs.stdenv.hostPlatform.system}.hyprtasking      
    ];

    extraConfig = builtins.readFile ./hyprland.lua;

    settings = {};
  };
}