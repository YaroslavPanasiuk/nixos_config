{ pkgs, inputs, ... }:
{  
  environment.systemPackages = with pkgs; [
    obsidian
    onlyoffice-bin
    obs-studio
    wget
    flatpak
    telegram-desktop
    appimage-run
    ventoy-full
    vlc
    home-manager
    python3Full
    python312Full
    nix-index
    qimgv
    zoom-us
    cmake
    gnumake
    brightnessctl	
    xdotool
    pywal
    libinput
    glib
    kando
    gvfs
    pinta
    ffmpeg
    fuse
    haskellPackages.libfuse3
    iproute2
    libosinfo
    curl
    nwg-dock-hyprland
    file
    wmctrl
    scrcpy
    android-tools
    qemu
    libvirt
    mpvpaper
    virt-manager
    OVMF 
    (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
          qemu-system-x86_64 \
          -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
          "$@"
    '')
    virt-viewer
    spice
    win-virtio
    virtiofsd
    libxml2
    libxslt
    fd
    zip
    imagemagick
    jq
    zenity
    ags
    ghostscript
    bc
    xorg.xkill
    xorg.xauth
    pinentry-gtk2
    gnum4
    parted
    pandoc
    gettext
    vscode
    gnupg
    xfce.xfce4-settings
    #waydroid
    gtk3
    gtk4
    nix-prefetch-git
    wpgtk
    gnome-multi-writer
    swappy
    postman
    wl-clipboard
    wf-recorder
    socat
    map-cmd
    pavucontrol
    nm-tray
    blueman
    gnome-power-manager
    hyprlock
    hyprpicker
    hyprlandPlugins.hyprspace
    xorg.xrdb
    gammastep
    lxqt.lxqt-policykit
    dunst
    gdrive3
    plocate
    zeitgeist
    xclip
    cifs-utils
    libreoffice
    poppler_utils
    gimp
    kdePackages.kdenlive
    parabolic
    libnotify
    swww
    kitty
    rofi-wayland
    hyprshot
    protonup
    mission-center
    pulseaudioFull
    pipewire
    playerctl
    ani-cli
    hyprsunset
    gparted
    cliphist
    woomer
    fh
    quickemu
    losslesscut-bin
    textpieces
    #stirling-pdf
    earlyoom
    lzip
    viber
    #nodejs_23
    mpv
    #figma-linux
    varia
    devenv
    neovim
    wayvnc
    
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
    (import ../scripts/cleanup.nix { inherit pkgs; })
    (import ../scripts/toggle_dock.nix { inherit pkgs; })
    (import ../scripts/idle_action.nix { inherit pkgs; })
    (import ../scripts/waydroid_init.nix { inherit pkgs; })
    (import ../scripts/vnc_server.nix { inherit pkgs; })
  ];
}
