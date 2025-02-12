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
                on-timeout = "if ! media_is_playing.sh; then loginctl lock-session; fi";
            }
            {
                timeout = 900;
                on-timeout = "if ! media_is_playing.sh; then hyprctl dispatch dpms off; fi";
                on-resume = "hyprctl dispatch dpms on";
            }
            {
                timeout = 1800;
                on-timeout = "if ! media_is_playing.sh; then systemctl suspend; fi";
            }
        ];
    };

  };

}