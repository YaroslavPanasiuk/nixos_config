{ pkgs, ... }:
let
  watchdog = import ../scripts/watchdog.nix { inherit pkgs; };
in
{  
  systemd = {

    packages = [ pkgs.libinput-gestures ];

    user.services.multi-sync-watcher = {
        description = "Inotify and rsync multiple folders watcher";
        wantedBy = [ "default.target" ];
        after = [ "network-online.target" ];
        
        path = with pkgs; [ inotify-tools rsync openssh bash ];

        serviceConfig = {
            ExecStart = "${watchdog}/bin/watchdog.sh";
            Restart = "always";
            RestartSec = "10s";
        };
    };

  };
}