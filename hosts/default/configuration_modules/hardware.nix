{ pkgs, ... }:
let
  user = import ./user.nix;
in
{  
  hardware = {

    graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
            intel-compute-runtime
            intel-media-driver
        ];
    };

    bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
            General = {
                Enable = "Source,Sink,Media,Socket";
                Experimental = true;
            };
        };
    };

    printers = {
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

    nvidia = {
        modesetting.enable = true;
        
        open = true; 

        powerManagement.enable = true;
        powerManagement.finegrained = false;

        prime = {
        offload = {
            enable = true;
            enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        };
    };
    
  };
}