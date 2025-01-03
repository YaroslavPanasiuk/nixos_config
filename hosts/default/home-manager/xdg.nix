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
        "application/vnd.oasis.opendocument.text" = [ "org.gnome.Evince.desktop" ];
        "application/epup+zip" = [ "org.gnome.Evince.desktop" ];

        "application/zip" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-tar" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-7z-compressed" = [ "org.gnome.FileRoller.desktop" ];
        "application/gzip" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-rar-compressed" = [ "org.gnome.FileRoller.desktop" ];

        "inode/directory" = [ "thunar.desktop" ];
      };
    };
  };
}