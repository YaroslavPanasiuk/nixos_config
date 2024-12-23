{ pkgs, modulesPath, inputs, ... }: {

  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    inputs.home-manager.nixosModules.default
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot.initrd.systemd.dbus.enable = true;
  boot.loader.systemd-boot.enable = true;
  services.dbus.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  systemd.packages = [ pkgs.libinput-gestures ];
  boot.extraModulePackages = [ pkgs.linuxPackages.v4l2loopback ];
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

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "yaros" = import ./home.nix;
    };
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

  services.displayManager.sddm = {
    wayland.enable = true;
    enable = true;
    #theme = "${import ./sddm-theme.nix {inherit pkgs;}}";
  };

  security.wrappers.fusermount = {
    source = "${pkgs.fuse}/bin/fusermount";
    setuid = true;
  };

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
    #desktopManager.gnome.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import <nixos-unstable> { };
  };

  services.printing.enable = true;

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

  users.users.yaros = {
    isNormalUser = true;
    password = "1972";
    description = "Yaroslav Panasiuk";
    extraGroups = [ "networkmanager" "wheel" "input" "libvirtd" "libvirt" "kvm" "adbusers"];
  };

  security.sudo.configFile = "yaros ALL=(ALL) NOPASSWD: ALL";

  programs.firefox.enable = true;
  
  services.flatpak.enable = true;
  
  programs.git = {
    enable = true;
    #userName  = "YaroslavPanasiuk";
    #userEmail = "yaroslav.panasiuk@lnu.edu.ua";
  };
  
  programs.hyprland.enable = true;

  programs.dconf.enable = true;

  programs.thunar.enable = true; 
  programs.xfconf.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
	thunar-archive-plugin
	thunar-media-tags-plugin
	thunar-volman
  ];
  services.gvfs.enable = true;
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

  #programs.steam = {
  #	enable = true;
  #	remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
 #	dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
 #	localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  #};

  #services.bluetooth.enable = true;
  services.blueman.enable = true;


  services.udev.packages = [
    pkgs.android-udev-rules
  ];


  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
	obsidian
	onlyoffice-bin
	obs-studio
  wget
  flatpak
  telegram-desktop
  appimage-run
  #snapcraft
  ventoy-full
  nixos-generators
  vlc
  home-manager
	python3Full
  python3
  apt
  nix-index
	#sublime
  qimgv
  zoom-us
	brightnessctl	
	#kdePackages.kdenlive
	xdotool
	pywal
  libinput
  anbox
  teams-for-linux
  libinput-gestures
	glib
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

  #hyprlandPlugins.hyprgrass

	file
  wmctrl
  scrcpy
  android-tools
  qemu
  #remmina
  davinci-resolve
  libvirt
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
  poetry
  #vivaldi
  #win-spice
  #quickemu
	xfce.catfish
	xfce.exo
	libxml2
	libxslt
	fd
  #lxappearance
	zip
	imagemagick
  jq
  #wineWowPackages.waylandFull
  #winetricks
  ags
	ghostscript
	libsForQt5.qt5.qtquickcontrols2
	libsForQt5.qt5.qtgraphicaleffects
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
	xwayland
	gtk4
  nix-prefetch-git
  wpgtk
	gnome-multi-writer
	waybar
  swappy
  wl-clipboard
  wf-recorder
	map-cmd
	pavucontrol
	nm-tray
	killall
  blueman
  gnome-power-manager
  hyprshot
  hyprlandPlugins.hyprspace
  xorg.xrdb
  networkmanagerapplet
	gammastep
	lxqt.lxqt-policykit
	geoclue2  
	(waybar.overrideAttrs(oldAttrs: {mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];}))
  dunst
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
    (import ./scripts/poweroff.nix { inherit pkgs; })
    (import ./scripts/restart.nix { inherit pkgs; })
  ];

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

   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  system.stateVersion = "unstable"; # Did you read the comment?

}