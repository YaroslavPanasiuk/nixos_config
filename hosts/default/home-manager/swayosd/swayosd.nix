{ config, pkgs, inputs, ... }:

{
  services.swayosd = {
    enable = true;
    topMargin = 0.95;
  };
}