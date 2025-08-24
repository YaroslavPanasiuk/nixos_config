{ inputs, ... }:
{  
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = [ "code.desktop" ];
        "inode/x-empty" = [ "code.desktop" ];
        "application/x-zerosize" = [ "code.desktop" ];
        "application/json" = [ "code.desktop" ];
        "text/css" = [ "code.desktop" ];
        "text/javascript" = [ "code.desktop" ];
        "text/markdown" = [ "code.desktop" ];
        "text/csv" = [ "code.desktop" ];
        "text/html" = [ "code.desktop" ];
        "text/htmlh" = [ "code.desktop" ];
        "text/x-adasrc" = [ "code.desktop" ];
        "text/x-authors" = [ "code.desktop" ];
        "text/x-basic" = [ "code.desktop" ];
        "text/x-bibtex" = [ "code.desktop" ];
        "text/x-blueprint" = [ "code.desktop" ];
        "text/x-changelog" = [ "code.desktop" ];
        "text/x-c++hdr" = [ "code.desktop" ];
        "text/x-chdr" = [ "code.desktop" ];
        "text/x-cmake" = [ "code.desktop" ];
        "text/x-cobol" = [ "code.desktop" ];
        "text/x-common-lisp" = [ "code.desktop" ];
        "text/x-component" = [ "code.desktop" ];
        "text/x-copying" = [ "code.desktop" ];
        "text/x-credits" = [ "code.desktop" ];
        "text/x-crystal" = [ "code.desktop" ];
        "text/x-csharp" = [ "code.desktop" ];
        "text/x-c++src" = [ "code.desktop" ];
        "text/x-csrc" = [ "code.desktop" ];
        "text/x-dbus-service" = [ "code.desktop" ];
        "text/x-dcl" = [ "code.desktop" ];
        "text/x-devicetree-binary" = [ "code.desktop" ];
        "text/x-devicetree-source" = [ "code.desktop" ];
        "text/x-dsl" = [ "code.desktop" ];
        "text/x-dsrc" = [ "code.desktop" ];
        "text/x-eiffel" = [ "code.desktop" ];
        "text/x-elixir" = [ "code.desktop" ];
        "text/x-emacs-lisp" = [ "code.desktop" ];
        "text/x-erlang" = [ "code.desktop" ];
        "text/x-fortran" = [ "code.desktop" ];
        "text/x.gcode" = [ "code.desktop" ];
        "text/x-gcode-gx" = [ "code.desktop" ];
        "text/x-genie" = [ "code.desktop" ];
        "text/x-gettext-translation" = [ "code.desktop" ];
        "text/x-gettext-translation-template" = [ "code.desktop" ];
        "text/x-gherkin" = [ "code.desktop" ];
        "text/x-go" = [ "code.desktop" ];
        "text/x-google-video-pointer" = [ "code.desktop" ];
        "text/x-gradle" = [ "code.desktop" ];
        "text/x-groovy" = [ "code.desktop" ];
        "text/x-haskell" = [ "code.desktop" ];
        "text/x-idl" = [ "code.desktop" ];
        "text/x-iMelody" = [ "code.desktop" ];
        "text/x-install" = [ "code.desktop" ];
        "text/x-iptables" = [ "code.desktop" ];
        "text/x-java" = [ "code.desktop" ];
        "text/x-kaitai-struct" = [ "code.desktop" ];
        "text/x-kotlin" = [ "code.desktop" ];
        "text/x-ldif" = [ "code.desktop" ];
        "text/x-lilypond" = [ "code.desktop" ];
        "text/x-literate-haskell" = [ "code.desktop" ];
        "text/x-log" = [ "code.desktop" ];
        "text/x-lua" = [ "code.desktop" ];
        "text/x-makefile" = [ "code.desktop" ];
        "text/x-matlab" = [ "code.desktop" ];
        "text/x-maven+xml" = [ "code.desktop" ];
        "text/xmcd" = [ "code.desktop" ];
        "text/x-meson" = [ "code.desktop" ];
        "text/x-microdvd" = [ "code.desktop" ];
        "text/x-moc" = [ "code.desktop" ];
        "text/x-modelica" = [ "code.desktop" ];
        "text/x-mof" = [ "code.desktop" ];
        "text/x-mpl2" = [ "code.desktop" ];
        "text/x-mpsub" = [ "code.desktop" ];
        "text/x-mrml" = [ "code.desktop" ];
        "text/x-ms-regedit" = [ "code.desktop" ];
        "text/x-mup" = [ "code.desktop" ];
        "text/x-nfo" = [ "code.desktop" ];
        "text/x-nim" = [ "code.desktop" ];
        "text/x-nimscript" = [ "code.desktop" ];
        "text/x-objc++src" = [ "code.desktop" ];
        "text/x-objcsrc" = [ "code.desktop" ];
        "text/x-ocaml" = [ "code.desktop" ];
        "text/x-ocl" = [ "code.desktop" ];
        "text/x-ooc" = [ "code.desktop" ];
        "text/x-opencl-src" = [ "code.desktop" ];
        "text/x-opml+xml" = [ "code.desktop" ];
        "text/x-pascal" = [ "code.desktop" ];
        "text/x-patch" = [ "code.desktop" ];
        "text/x-python" = [ "code.desktop" ];
        "text/x-python3" = [ "code.desktop" ];
        "text/x-qml" = [ "code.desktop" ];
        "text/x-readme" = [ "code.desktop" ];
        "text/x-reject" = [ "code.desktop" ];
        "text/x-rpm-spec" = [ "code.desktop" ];
        "text/x-rst" = [ "code.desktop" ];
        "text/x-sagemath" = [ "code.desktop" ];
        "text/x-sass" = [ "code.desktop" ];
        "text/x-scala" = [ "code.desktop" ];
        "text/x-scheme" = [ "code.desktop" ];
        "text/x-scons" = [ "code.desktop" ];
        "text/x-scss" = [ "code.desktop" ];
        "text/x-setext" = [ "code.desktop" ];
        "text/x-ssa" = [ "code.desktop" ];
        "text/x-subviewer" = [ "code.desktop" ];
        "text/x-svhdr" = [ "code.desktop" ];
        "text/x-svsrc" = [ "code.desktop" ];
        "text/x-systemd-unit" = [ "code.desktop" ];
        "text/x-tex" = [ "code.desktop" ];
        "text/x-texinfo" = [ "code.desktop" ];
        "text/x-todo-txt" = [ "code.desktop" ];
        "text/x-troff-me" = [ "code.desktop" ];
        "text/x-troff-mm" = [ "code.desktop" ];
        "text/x-troff-ms" = [ "code.desktop" ];
        "text/x-twig" = [ "code.desktop" ];
        "text/x-txt2tags" = [ "code.desktop" ];
        "text/x-typst" = [ "code.desktop" ];
        "text/x-uil" = [ "code.desktop" ];
        "text/x-uri" = [ "code.desktop" ];
        "text/x-uuencode" = [ "code.desktop" ];
        "text/x-vala" = [ "code.desktop" ];
        "text/x-vb" = [ "code.desktop" ];
        "text/x-verilog" = [ "code.desktop" ];
        "text/x-vhdl" = [ "code.desktop" ];
        "text/x-xmi" = [ "code.desktop" ];
        "text/x-xslfo" = [ "code.desktop" ];
        
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
        "application/msword" = [ "writer.desktop" "onlyoffice-desktopeditors.desktop" ];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "writer.desktop" "onlyoffice-desktopeditors.desktop" ];
        "application/vnd.ms-excel" = [ "calc.desktop" ];
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	.xlsx" = [ "calc.desktop" "onlyoffice-desktopeditors.desktop" ];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [ "impress.desktop" "onlyoffice-desktopeditors.desktop" ];
        "application/vnd.ms-powerpoint" = [ "impress.desktop" "onlyoffice-desktopeditors.desktop" ];
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

        "x-scheme-handler/http" = [ "zen.desktop" ];
        "x-scheme-handler/https" = [ "zen.desktop" ];
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
    "kando/sound-themes" = {
      enable = true;
      recursive = true;
      source = ./kando/sound-themes;
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
      enable = false;
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
    "gtt" = {
      enable = true;
      recursive = true;
      source = ./gtt;
    };
    "sys64/hud" = {
      enable = true;
      recursive = true;
      source = ./syshud;
    };
    "anyrun/style.css" = {
      enable = true;
      source = ./anyrun/style.css;
    };
    "anyrun/libtranslate_panas.so" = {
      enable = true;
      source = ./anyrun/libtranslate_panas.so;
    };
    "goal-tracker/style.css" = {
      enable = true;
      source = ./goal-tracker/style.css;
    };
    "GIMP/2.10/scripts" = {
      enable = true;
      recursive = true;
      source = ../scripts/gimp;
    };
  };

  };
}