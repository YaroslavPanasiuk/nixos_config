{ inputs, ... }:
{  
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = [ "code.desktop" ];
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
        "application/msword" = [ "org.gnome.Evince.desktop" ];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "org.gnome.Evince.desktop" ];
        "application/vnd.ms-excel" = [ "org.gnome.Evince.desktop" ];
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	.xlsx" = [ "org.gnome.Evince.desktop" ];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [ "onlyoffice-desktopeditors.desktop" "org.gnome.Evince.desktop" ];
        "application/vnd.ms-powerpoint" = [ "onlyoffice-desktopeditors.desktop" "org.gnome.Evince.desktop" ];
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
    "kando" = {
      enable = false;
      recursive = true;
      source = ./kando;
    };
    "rofi" = {
      enable = true;
      recursive = true;
      source = ./rofi;
    };
    "dunst/dunstrc" = {
      enable = true;
      source = ./dunst/dunstrc;
    };
    "hypr/greeting.conf" = {
      enable = true;
      source = ./hyprland/greeting.conf;
    };
    "vlc" = {
      enable = true;
      recursive = true;
      source = ./vlc;
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
    "touchegg" = {
      enable = false;
      recursive = true;
      source = ./touchegg;
    };
    "nwg-dock-hyprland" = {
      enable = true;
      recursive = true;
      source = ./nwg-dock-hyprland;
    };
  };

  };
}