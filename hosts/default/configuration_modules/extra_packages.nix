{ pkgs, ... }:
{  
  environment.systemPackages = with pkgs; [
    obsidian
    #jetbrains.pycharm-community
    onlyoffice-bin
    obs-studio
    wget
    flatpak
    telegram-desktop
    appimage-run
    #snapcraft
    ventoy-full
    #nixos-generators
    vlc
    home-manager
    python3Full
    python3
    #apt
    nix-index
    #sublime
    qimgv
    zoom-us
    cmake
    brightnessctl	
    #kdePackages.kdenlive
    xdotool
    pywal
    libinput
    #anbox
    #teams
    #teams-for-linux
    #libinput-gestures
    glib
    kando
    gvfs
    pinta
    ffmpeg
    wofi
    fuse
    haskellPackages.libfuse3
    #appimage-run
    iproute2
    libosinfo
    curl
    #steamcmd
    #fprintd

    #hyprlandPlugins.hyprgrass

    nwg-dock-hyprland
    #nwg-drawer
    file
    wmctrl
    scrcpy
    android-tools
    qemu
    #remmina
    #davinci-resolve
    libvirt
    mpvpaper
    virt-manager  # Optional, for managing VMs with a GUI
    OVMF 
    (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
          qemu-system-x86_64 \
          -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
          "$@"
    '')
    virt-viewer
    spice
    #spice-gtk
    #spice-protocol
    win-virtio
    virtiofsd
    #poetry
    #vivaldi
    #win-spice
    #quickemu
    #xfce.catfish
    #xfce.exo
    libxml2
    libxslt
    fd
    #lxappearance
    zip
    imagemagick
    jq
    zenity
    #wineWowPackages.waylandFull
    #winetricks
    ags
    ghostscript
    #libsForQt5.qt5.qtquickcontrols2
    #libsForQt5.qt5.qtgraphicaleffects
    bc
    xorg.xkill
    xorg.xauth
    pinentry-gtk2
    gnum4
    parted
    pandoc
    gettext
    python311Packages.lxml	
    python312Packages.lxml
    #gparted
    vscode
    gnupg
    xfce.xfce4-settings
    waydroid
    gtk3
    #xwayland
    gtk4
    nix-prefetch-git
    wpgtk
    gnome-multi-writer
    #waybar
    swappy
    postman
    wl-clipboard
    wf-recorder
    socat
    map-cmd
    pavucontrol
    nm-tray
    killall
    #matugen
    blueman
    gnome-power-manager
    hyprlock
    hyprpicker
    hyprshot
    hyprlandPlugins.hyprspace
    xorg.xrdb
    #networkmanagerapplet
    gammastep
    lxqt.lxqt-policykit
    #geoclue2  
    dunst
    gdrive3
    plocate
    zeitgeist
    xclip
    cifs-utils
    libreoffice
    poppler_utils
  ] ++ [
  	libnotify
  	swww
	  rofi-wayland
  	kitty
  ] ++ [
    (import ../scripts/volume.nix { inherit pkgs; })
    (import ../scripts/backup.nix { inherit pkgs; })
    (import ../scripts/brightness.nix { inherit pkgs; })
    (import ../scripts/mp4_to_wallp.nix { inherit pkgs; })
    (import ../scripts/phone_camera.nix { inherit pkgs; })
    (import ../scripts/push_sddm.nix { inherit pkgs; })
    (import ../scripts/push_wallp.nix { inherit pkgs; })
    (import ../scripts/rebuild.nix { inherit pkgs; })
    (import ../scripts/record_screen.nix { inherit pkgs; })
    (import ../scripts/record_screen_as_camera.nix { inherit pkgs; })
    (import ../scripts/reload_firefox.nix { inherit pkgs; })
    (import ../scripts/set_welcome.nix { inherit pkgs; })
    (import ../scripts/start_macos.nix { inherit pkgs; })
    (import ../scripts/start_waydroid.nix { inherit pkgs; })
    (import ../scripts/start_windows.nix { inherit pkgs; })
    (import ../scripts/stop_waydroid.nix { inherit pkgs; })
    (import ../scripts/stop_windows.nix { inherit pkgs; })
    (import ../scripts/wallp-rofi.nix { inherit pkgs; })
    (import ../scripts/kill_taskbar.nix { inherit pkgs; })
    (import ../scripts/kill_waybar.nix { inherit pkgs; })
    (import ../scripts/open_calendar.nix { inherit pkgs; })
    (import ../scripts/post_wallp_change.nix { inherit pkgs; })
    (import ../scripts/redshift.nix { inherit pkgs; })
    (import ../scripts/set_wallpaper.nix { inherit pkgs; })
    (import ../scripts/update_telegram.nix { inherit pkgs; })
    (import ../scripts/wallpaper_change.nix { inherit pkgs; })
    (import ../scripts/wallp_status.nix { inherit pkgs; })
    (import ../scripts/wallp.nix { inherit pkgs; })
    (import ../scripts/alttab.nix { inherit pkgs; })
    (import ../scripts/install.nix { inherit pkgs; })
    (import ../scripts/toggle_wifi.nix { inherit pkgs; })
    (import ../scripts/swipe_up.nix { inherit pkgs; })
    (import ../scripts/swipe_down.nix { inherit pkgs; })
    (import ../scripts/launch_dock.nix { inherit pkgs; })
    (import ../scripts/toggle_mpvpaper.nix { inherit pkgs; })
    (import ../scripts/toggle_hyprpanel.nix { inherit pkgs; })
    (import ../scripts/set_as_wallpaper.nix { inherit pkgs; })
    (import ../scripts/backup_usb.nix { inherit pkgs; })
    (import ../scripts/generate_ssh.nix { inherit pkgs; })
    (import ../scripts/set_layout.nix { inherit pkgs; })
    (import ../scripts/export_images.nix { inherit pkgs; })
  ];
}
