{ pkgs, ... }:
let
  user = import ./user.nix;
in
{  
  boot = {

    plymouth = {
      enable = true;
      theme = "colorful_loop";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "colorful_loop" ];
        })
      ];
    };

    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "plymouth.use-simpledrm"
    ];
    
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = false;
        configurationLimit = 7;
        editor = false;
        consoleMode = "max";
        windows."Windows" = {
          efiDeviceHandle = "HD1b";
          title = "Michaelsoft Binbows";
        };
        extraEntries = {
          "memtest86.conf" = ''
            title grub
            efi /EFI/grub/grubx64.efi
          '';
        };
        edk2-uefi-shell.enable = true;
      };

      grub = {
        enable                = true;
        useOSProber           = true;
        copyKernels           = true;
        efiSupport            = true;
        fsIdentifier          = "uuid";
        device               = "nodev";
        configurationLimit = 20;
        splashImage = "${user.path}/nixos/hosts/default/home-manager/extra_resources/VeryBlurredBackground.jpg";
        theme = "${user.path}/nixos/hosts/default/grub/bigsur";
        extraEntries = ''
          menuentry "Boot from USB" --class usb {
            insmod ext2
            insmod fat
            insmod exfat
            insmod ntfs
            insmod chain
            insmod usb
            search --set=root --fs-uuid 223C-F3F8
            chainloader /EFI/BOOT/BOOTX64.EFI
          } 
          menuentry "Reboot" --class restart {
            reboot
          }
          menuentry "Poweroff" --class shutdown {
            halt
          }
        '';
      };
    };
    
    
    extraModulePackages = [ pkgs.linuxPackages.v4l2loopback ];
    kernelModules = [ "v4l2loopback" "binder_linux" "ashmem_linux" ];
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };

  };
}