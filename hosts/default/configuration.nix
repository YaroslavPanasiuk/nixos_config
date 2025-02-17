{ lib, config, pkgs, inputs, ... }:
let
  user = import ./configuration_modules/user.nix;
in
{
  imports =
    [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ./configuration_modules/boot.nix
      #./configuration_modules/scripts.nix
      ./configuration_modules/services.nix
      ./configuration_modules/programs.nix
      ./configuration_modules/extra_packages.nix
      ./configuration_modules/fonts.nix
    ];  

  systemd.packages = [ pkgs.libinput-gestures ];
 
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.enable = true;
    firewall.allowPing = true;
    firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  };
  
  home-manager = {
    users = {
      ${user.name} = import ./home.nix;
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

  users.users.${user.name} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "input" "libvirtd" "libvirt" "kvm" "adbusers"];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import <nixos-unstable> { };
  };
  nixpkgs.overlays = [inputs.hyprpanel.overlay];
 
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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
        intel-compute-runtime
    ];
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]);

  system.stateVersion = "unstable";

}
