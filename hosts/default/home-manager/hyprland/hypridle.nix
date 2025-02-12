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
                on-timeout = "/run/current-system/sw/bin/idle_action.sh dim";
                on-resume = "brightnessctl -r";
            }
            {
                timeout = 600;
                on-timeout = "/run/current-system/sw/bin/idle_action.sh lock";
            }
            {
                timeout = 900;
                on-timeout = "/run/current-system/sw/bin/idle_action.sh dpms";
                on-resume = "hyprctl dispatch dpms on";
            }
            {
                timeout = 1800;
                on-timeout = "/run/current-system/sw/bin/idle_action.sh suspend";
            }
        ];
    };

  };

}