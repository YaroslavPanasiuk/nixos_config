{ lib, config, pkgs, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.initrd.systemd.dbus.enable = true;
  boot.loader.systemd-boot.enable = true;
  services.dbus.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  systemd.packages = [ pkgs.libinput-gestures ];
  #systemd.unified_cgroup_hierarchy = 1;

  # Enable v4l2loopback kernel module
  boot.extraModulePackages = [ pkgs.linuxPackages.v4l2loopback ];

  # Optionally, load the module at boot
  boot.kernelModules = [ "v4l2loopback" "binder_linux" "ashmem_linux" ];

  boot.kernelParams = [ "systemd.unified_cgroup_hierarchy=1" ];
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.enable = true;
    firewall.allowPing = true;
    firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  };
  
  home-manager = {
    users = {
      "yaros" = import ./home.nix;
    };
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "hm-backup";
  };

  time.timeZone = "Europe/Kyiv";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "uk_UA.UTF-8";
    LC_IDENTIFICATION = "uk_UA.UTF-8";
    LC_MEASUREMENT = "uk_UA.UTF-8";
    LC_MONETARY = "uk_UA.UTF-8";
    LC_NAME = "uk_UA.UTF-8";
    LC_NUMERIC = "uk_UA.UTF-8";
    LC_PAPER = "uk_UA.UTF-8";
    LC_TELEPHONE = "uk_UA.UTF-8";
    LC_TIME = "uk_UA.UTF-8";
  };

  #services.displayManager.sddm = {
  #  wayland.enable = true;
  #  enable = true;
  #  theme = "${import ./sddm/sddm-theme.nix {inherit pkgs;}}";
  #};

  security.wrappers.fusermount = {
    source = "${pkgs.fuse}/bin/fusermount";
    setuid = true;
  };
  security = {
    polkit.enable = true;
    pam.services.hyprlock = {};
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
  };
  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.touchegg.enable = true;

  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  #sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yaros = {
    isNormalUser = true;
    description = "Yaroslav Panasiuk";
    extraGroups = [ "networkmanager" "wheel" "input" "libvirtd" "libvirt" "kvm" "adbusers"];
    password = "1";
  };

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "Hyprland";
        user = "yaros";
      };
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.hyprlock.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import <nixos-unstable> { };
  };
  nixpkgs.overlays = [inputs.hyprpanel.overlay];
  
  services.flatpak.enable = true;
  
  programs.hyprland = {
    enable = true;
    #package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  programs.dconf.enable = true;

  programs.thunar.enable = true; 
  programs.xfconf.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-media-tags-plugin
    thunar-volman
  ];
  services.gvfs.enable = true;
  services.gvfs.package = lib.mkForce pkgs.gnome.gvfs;
  services.tumbler.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
    waydroid.enable = true;
    lxd.enable = true;
    #anbox.enable = true;
  };
  services.spice-vdagentd.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  	stdenv.cc.cc.lib
  	zlib
  ];
  programs.adb.enable = true;
  #xdg.portal.enable = true;

   hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
        intel-compute-runtime
    ];
  };

  services.openssh.enable = true;


  #xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  programs.steam = {
  	enable = true;
  	remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  	dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
 	  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  #services.bluetooth.enable = true;
  services.blueman.enable = true;


  services.udev.packages = [
    pkgs.android-udev-rules
  ];

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
  davinci-resolve
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
  ] ++ [
  	libnotify
  	swww
	  rofi-wayland
  	kitty
  ] ++ [
    (import ./scripts/volume.nix { inherit pkgs; })
    (import ./scripts/backup.nix { inherit pkgs; })
    (import ./scripts/battery_listener.nix { inherit pkgs; })
    (import ./scripts/battery_reset.nix { inherit pkgs; })
    (import ./scripts/brightness.nix { inherit pkgs; })
    (import ./scripts/layout_msg.nix { inherit pkgs; })
    (import ./scripts/mp4_to_wallp.nix { inherit pkgs; })
    (import ./scripts/phone_camera.nix { inherit pkgs; })
    (import ./scripts/push_sddm.nix { inherit pkgs; })
    (import ./scripts/push_wallp.nix { inherit pkgs; })
    (import ./scripts/rebuild.nix { inherit pkgs; })
    (import ./scripts/record_screen.nix { inherit pkgs; })
    (import ./scripts/record_screen_as_camera.nix { inherit pkgs; })
    (import ./scripts/reload_firefox.nix { inherit pkgs; })
    (import ./scripts/set_welcome.nix { inherit pkgs; })
    (import ./scripts/start_macos.nix { inherit pkgs; })
    (import ./scripts/start_waydroid.nix { inherit pkgs; })
    (import ./scripts/start_windows.nix { inherit pkgs; })
    (import ./scripts/stop_waydroid.nix { inherit pkgs; })
    (import ./scripts/stop_windows.nix { inherit pkgs; })
    (import ./scripts/wallp-rofi.nix { inherit pkgs; })
    (import ./scripts/kill_taskbar.nix { inherit pkgs; })
    (import ./scripts/kill_waybar.nix { inherit pkgs; })
    (import ./scripts/open_calendar.nix { inherit pkgs; })
    (import ./scripts/post_wallp_change.nix { inherit pkgs; })
    (import ./scripts/redshift.nix { inherit pkgs; })
    (import ./scripts/set_wallpaper.nix { inherit pkgs; })
    (import ./scripts/update_telegram.nix { inherit pkgs; })
    (import ./scripts/wallpaper_change.nix { inherit pkgs; })
    (import ./scripts/wallp_status.nix { inherit pkgs; })
    (import ./scripts/wallp.nix { inherit pkgs; })
    (import ./scripts/alttab.nix { inherit pkgs; })
    (import ./scripts/install.nix { inherit pkgs; })
    (import ./scripts/toggle_wifi.nix { inherit pkgs; })
    (import ./scripts/swipe_up.nix { inherit pkgs; })
    (import ./scripts/swipe_down.nix { inherit pkgs; })
    (import ./scripts/launch_dock.nix { inherit pkgs; })
    (import ./scripts/toggle_mpvpaper.nix { inherit pkgs; })
    (import ./scripts/toggle_hyprpanel.nix { inherit pkgs; })
    (import ./scripts/set_as_wallpaper.nix { inherit pkgs; })
    (import ./scripts/backup_usb.nix { inherit pkgs; })
    (import ./scripts/generate_ssh.nix { inherit pkgs; })

  ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
	noto-fonts
	noto-fonts-cjk-sans
	noto-fonts-emoji
	liberation_ttf
	fira-code
  vistafonts
  corefonts
	fira-code-symbols
	mplus-outline-fonts.githubRelease
	dina-font
	proggyfonts
	font-awesome
	nerd-fonts.ubuntu
  ]; 

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]);

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  system.stateVersion = "unstable";

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
        "hosts allow" = "192.168.31.220 192.168.31.231 192.168.122.156 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
      };
      "shared" = {
        "path" = "/home/yaros/shared";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "public" = "yes";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

}
