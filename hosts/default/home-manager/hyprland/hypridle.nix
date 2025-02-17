{ config, pkgs, inputs, ... }:
let 
    working_dir = "/run/current-system/sw/bin/";
in
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
                on-timeout = "${working_dir}playerctl status --all-players 2>/dev/null | ${working_dir}grep -q 'Playing' || ${working_dir}brightnessctl -s set 1";
                on-resume = "${working_dir}brightnessctl -r";
            }
            
            {
                timeout = 600;
                on-timeout = "${working_dir}playerctl status --all-players | ${working_dir}grep -q 'Playing' || ${working_dir}loginctl lock-session";
            }
            
            {
                timeout = 900;
                on-timeout = "${working_dir}playerctl status --all-players 2>/dev/null | ${working_dir}grep -q 'Playing' || $HOME/.nix-profile/bin/hyprctl dispatch dpms off";
                on-resume = "$HOME/.nix-profile/bin/hyprctl dispatch dpms on";
            }
            
            {
                timeout = 1800;
                on-timeout = "${working_dir}playerctl status --all-players 2>/dev/null | ${working_dir}grep -q 'Playing' || ${working_dir}systemctl suspend";
            }
            
        ];
    };

  };

}