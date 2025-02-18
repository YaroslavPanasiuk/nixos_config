{ inputs, ... }:
{  
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = [ "code.desktop" ];
        "inode/x-empty" = [ "code.desktop" ];
        "text/css" = [ "code.desktop" ];
        "text/javascript" = [ "code.desktop" ];
        "text/markdown" = [ "code.desktop" ];
        "text/csv" = [ "code.desktop" ];
        "text/html" = [ "code.desktop" ];
        "text/x-shellscript" = [ "code.desktop" ];
        
        "image/png" = [ "qimgv.desktop" ];
        "image/jpeg" = [ "qimgv.desktop" ];
        "image/gif" = [ "qimgv.desktop" ];
        "image/svg+xml" = [ "qimgv.desktop" ];
        "image/webp" = [ "qimgv.desktop" ];
        "image/bmp" = [ "qimgv.desktop" ];
        "image/tiff" = [ "qimgv.desktop" ];

        "audio/mpeg" = [ "vlc.desktop" ];
        "audio/ogg" = [ "vlc.desktop" ];
        "audio/wav" = [ "vlc.desktop" ];
        "audio/aac" = [ "vlc.desktop" ];
        "audio/webm" = [ "vlc.desktop" ];

        "video/mp4" = [ "vlc.desktop" ];
        "video/webm" = [ "vlc.desktop" ];
        "video/x-matroska" = [ "vlc.desktop" ];
        "video/ogg" = [ "vlc.desktop" ];
        "video/quicktime" = [ "vlc.desktop" ];
        "video/x-msvideo" = [ "vlc.desktop" ];

        "application/pdf" = [ "org.gnome.Evince.desktop" ];
        "application/msword" = [ "libreoffice-writer.desktop" "onlyoffice-desktopeditors.desktop" ];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "libreoffice-writer.desktop" "onlyoffice-desktopeditors.desktop" ];
        "application/vnd.ms-excel" = [ "libreoffice-calc.desktop" ];
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	.xlsx" = [ "libreoffice-calc.desktop" "onlyoffice-desktopeditors.desktop" ];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [ "libreoffice-impress.desktop" "onlyoffice-desktopeditors.desktop" ];
        "application/vnd.ms-powerpoint" = [ "libreoffice-impress.desktop" "onlyoffice-desktopeditors.desktop" ];
        "application/vnd.oasis.opendocument.text" = [ "org.gnome.Evince.desktop" ];
        "application/epup+zip" = [ "org.gnome.Evince.desktop" ];
        "application/x-shellscript" = [ "code.desktop" ];
        "application/x-sh" = [ "code.desktop" ];
        "application/octet-stream" = [ "code.desktop" ];

        "application/zip" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-tar" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-7z-compressed" = [ "org.gnome.FileRoller.desktop" ];
        "application/gzip" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-rar-compressed" = [ "org.gnome.FileRoller.desktop" ];

        "inode/directory" = [ "thunar.desktop" ];
      };
    };

    configFile = {
    "kando/icon-themes" = {
      enable = true;
      recursive = true;
      source = ./kando/icon-themes;
    };
    "kando/menu-themes" = {
      enable = true;
      recursive = true;
      source = ./kando/menu-themes;
    };
    "kando/menus.json" = {
      enable = true;
      source = ./kando/menus.json;
    };
    #"kando/config.json" = {
    #  enable = true;
    #  source = ./kando/config.json;
    #};
    "rofi" = {
      enable = true;
      recursive = true;
      source = ./rofi;
    };
    "dunst" = {
      enable = true;
      recursive = true;
      source = ./dunst;
    };
    "wal" = {
      enable = true;
      recursive = true;
      source = ./wal;
    };
    "walogram" = {
      enable = true;
      recursive = true;
      source = ./walogram;
    };
    "Thunar" = {
      enable = true;
      recursive = true;
      source = ./Thunar;
    };
    "touchegg/touchegg.conf" = {
      enable = true;
      source = ./touchegg/touchegg.conf;
    };
    "nwg-dock-hyprland" = {
      enable = true;
      recursive = true;
      source = ./nwg-dock-hyprland;
    };
    "hyprswitch" = {
      enable = true;
      recursive = true;
      source = ./hyprswitch;
    };
    "GIMP/2.10/scripts" = {
      enable = true;
      recursive = true;
      source = ../scripts/gimp;
    };
  };

  };
}