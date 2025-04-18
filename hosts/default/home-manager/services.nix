{ ... }:
let
  user = import ../configuration_modules/user.nix;
in
{  
  systemd.user.startServices = "sd-switch";
  systemd.user.services = {
    
    battery = {
      Unit = {
        Description = "Battery Level Checker";
      };
      Service = {
        Restart="always";
        RestartSec=30;
        ExecStart="/home/${user.name}/nixos/hosts/default/scripts/bash/battery_listener.sh";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    battery_reset = {
      Unit = {
        Description = "Battery service resetter";
      };
      Service = {
        Restart="always";
        RestartSec=900;
        ExecStart="/home/${user.name}/nixos/hosts/default/scripts/bash/battery_reset.sh";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}