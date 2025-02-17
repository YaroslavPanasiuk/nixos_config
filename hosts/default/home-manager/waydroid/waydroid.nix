{ pkgs, ... }: {
  imports = [ ./waydroid_option.nix ];

  waydroid = {
    enable = true;
    resolution = {
      width = 1080;
      height = 1920;
      density = 160;
    };
    
  };
}