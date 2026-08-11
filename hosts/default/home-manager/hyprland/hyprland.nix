{ config, pkgs, inputs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; 
    systemd.enable = true; 
    systemd.variables = ["--all"];

    plugins = [
      inputs.hyprtasking.packages.${pkgs.stdenv.hostPlatform.system}.hyprtasking      
    ];

    extraConfig = builtins.readFile ./hyprland.lua;

    settings = {};
  };
}