{ lib, config, pkgs, inputs, ... }:
let
  user = import ./configuration_modules/user.nix;
in
{
  imports =
    [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      inputs.hyprland.nixosModules.default
      ./configuration_modules/boot.nix
      #./configuration_modules/scripts.nix
      ./configuration_modules/services.nix
      ./configuration_modules/programs.nix
      ./configuration_modules/extra_packages.nix
      ./configuration_modules/fonts.nix
    ];  

  systemd.packages = [ pkgs.libinput-gestures ];

  nixpkgs.overlays = [ 
    #(import ./overlays/zerotierone.nix) 
    #(import ./overlays/varia.nix) 
  ];
 
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.enable = true;
    firewall.allowPing = true;
    firewall.allowedTCPPorts = [ 5900 ];
    firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  };
  
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ 
    pkgs.xdg-desktop-portal-gtk
    #pkgs.xdg-desktop-portal-hyprland
    #pkgs.xdg-desktop-portal-kde
  ];

  home-manager = {
    users = {
      ${user.name} = import ./home.nix;
    };
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";
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

  users.users.${user.name} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "input" "libvirtd" "libvirt" "kvm" "adbusers" "docker"];
  };
  nixpkgs.config.allowBroken = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import <nixos-unstable> { };
    #kando-180 = pkgs.callPackage ./packages/kando-180.nix { };
    #scrcpy-33 = pkgs.callPackage ./packages/scrcpy-33.nix { };
  };
 
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
    waydroid.enable = true;
    docker.enable = true;
    docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
        intel-compute-runtime
    ];
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Canon_MF420_Series";
        location = "Studpro";
        deviceUri = "dnssd://Canon%20MF420%20Series._ipp._tcp.local/?uuid=6d4ff0ce-6b11-11d8-8020-00bbc1742b65";
        model = "drv:///sample.drv/generic.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
    ensureDefaultPrinter = "Canon_MF420_Series";
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.extraOptions = ''
    trusted-users = root yarko
  '';

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]);

  environment.sessionVariables = {
    GTK_TOOLTIP_TIMEOUT = "1";
  };

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.07"
  ];

  system.stateVersion = "25.11";

}
