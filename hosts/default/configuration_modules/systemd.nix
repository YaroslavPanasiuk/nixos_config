{ pkgs, ... }:
let
  watchdog = import ../scripts/watchdog.nix { inherit pkgs; };
  sync_folders = import ../scripts/sync_folders.nix { inherit pkgs; };
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

    user.services.multi-sync-scheduler = {
      description = "cron rsync multiple folders scheduler";
      serviceConfig.ExecStart = "${sync_folders}/bin/sync_folders.sh";
    };

    user.timers.multi-sync-scheduler = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "Sun *-*-* 00:00:00";
        Persistent = true;
      };
    };

  };
}