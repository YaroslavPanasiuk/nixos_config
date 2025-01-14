{ config, pkgs, inputs, ... }:

{
  services.hypridle = {
    enable = true;

    settings = {
        general = {
            lock_cmd = "pidof hyprlock || hyprlock";       
            before_sleep_cmd = "loginctl lock-session";    
            after_sleep_cmd = "hyprctl dispatch dpms on";  
        };

        listener = [
            {
                timeout = 300;
                on-timeout = "brightnessctl -s set 1";
                on-resume = "brightnessctl -r";
            }
            {
                timeout = 600;
                on-timeout = "loginctl lock-session";
            }
            {
                timeout = 900;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
            }
            {
                timeout = 1800;
                on-timeout = "systemctl suspend";
            }
        ];
    };

  };

}