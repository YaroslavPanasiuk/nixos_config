{ ... }:
{  
  security = {
    wrappers.fusermount = {
      source = "${pkgs.fuse}/bin/fusermount";
      setuid = true;
      polkit.enable = true;
      pam.services.hyprlock = {};
      rtkit.enable = true;
    };

  };
}