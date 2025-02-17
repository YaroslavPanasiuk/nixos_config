{ config, pkgs, lib, ... }:
let
  inherit (lib) types mkIf mkOption mkEnableOption;
in
{
  options.waydroid = {
    enable = mkEnableOption "Enable Waydroid configuration";
    resolution = {
      width = mkOption {
        type = types.int;
        default = 1080;
        description = "Screen width in pixels";
      };
      height = mkOption {
        type = types.int;
        default = 1920;
        description = "Screen height in pixels";
      };
      density = mkOption {
        type = types.int;
        default = 160;
        description = "Screen density (DPI)";
      };
    };
    apps = {
      enable = mkEnableOption "Enable preinstalled apps";
      apkFiles = mkOption {
        type = types.listOf types.path;
        default = [];
        description = "List of APK files to install";
      };
    };
  };

  config = mkIf config.waydroid.enable {
    home.packages = with pkgs; [ waydroid ];

    xdg.configFile."waydroid/waydroid_base.prop".text = ''
      ro.sf.lcd_density=${toString config.waydroid.resolution.density}
      ro.sf.width=${toString config.waydroid.resolution.width}
      ro.sf.height=${toString config.waydroid.resolution.height}
    '';

    xdg.configFile."waydroid/install-apps.sh" = {
      text = ''
        #!/usr/bin/env bash
        ${toString (map (apk: "waydroid app install ${apk}\n") config.waydroid.apps.apkFiles)}
      '';
      executable = true;
    };

    systemd.user.services.waydroid-app-installer = {
      Unit = {
        Description = "Install apps into Waydroid";
        After = [ "waydroid-session.service" ];
      };
      Service = {
        ExecStart = "${pkgs.bash}/bin/bash %h/.config/waydroid/install-apps.sh";
        Type = "oneshot";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}