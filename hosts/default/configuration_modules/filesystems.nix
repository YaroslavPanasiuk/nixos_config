{ pkgs, ... }:
{  
  system.fsPackages = [ pkgs.sshfs ];
  programs.fuse.userAllowOther = true;

  fileSystems = {

    #"/mnt/server_nas" = {
    #  device = "//100.113.11.199/NetBird_NAS";
    #  fsType = "cifs";
    #  options = [
    #    "x-systemd.automount"
    #    "x-systemd.requires=network-online.target"
    #    "noauto"
    #    "x-systemd.idle-timeout=60"
    #    "x-systemd.device-timeout=5s"
    #    "x-systemd.mount-timeout=5s"
    #    "noauto"
    #    "x-gvfs-hide"
    #    "username=yaros"
    #    "password=1246"
    #  ];
    #};

    "/mnt/server_HP" = {
        device = "yaros@92.253.238.166:/home/yaros";
        fsType = "fuse.sshfs";
        options = [
          "port=22022"
          "IdentityFile=/root/.ssh/id_ed25519"
          "StrictHostKeyChecking=accept-new"
          "allow_other"
          "noauto"
          "x-gvfs-hide"
          "_netdev"
          "x-systemd.automount"
          "x-systemd.requires=network-online.target"
          "reconnect"
          "rw"
          "uid=1000"
          "gid=100"
        ];
    }; 

    "/mnt/server_DELL" = {
        device = "yaros@92.253.238.166:/home/yaros";
        fsType = "fuse.sshfs";
        options = [
          "port=22122"
          "IdentityFile=/root/.ssh/id_ed25519"
          "StrictHostKeyChecking=accept-new"
          "allow_other"
          "noauto"
          "x-gvfs-hide"
          "_netdev"
          "x-systemd.automount"
          "x-systemd.requires=network-online.target"
          "reconnect"
          "rw"
          "uid=1000"
          "gid=100"
        ];
    }; 

    "/mnt/HDD" = {
        device = "/dev/disk/by-uuid/a523c141-f339-41e2-adde-8cb90c95bdbf";
        fsType = "ext4";
        options = [ "defaults" ];
    };
  };
}