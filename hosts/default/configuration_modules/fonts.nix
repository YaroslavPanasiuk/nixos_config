{ pkgs, ... }:
{  
  fonts = {
    fontconfig.enable = true;

    

    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      vista-fonts
      corefonts
      fira-code-symbols
      nerd-fonts.caskaydia-cove
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      font-awesome
      openmoji-color
      fantasque-sans-mono
      roboto
      dejavu_fonts
      ttf_bitstream_vera
      nerd-fonts.ubuntu
      (stdenv.mkDerivation {
        name = "ttnorms-bold";
        src = ../fonts/ttnorms;
        installPhase = ''
          mkdir -p $out/share/fonts/truetype
          cp $src/*.ttf $out/share/fonts/truetype/
        '';
      })
      (stdenv.mkDerivation {
        name = "shine_in_valentine";
        src = ../fonts/shine_in_valentine;
        installPhase = ''
          mkdir -p $out/share/fonts/truetype
          cp $src/*.ttf $out/share/fonts/truetype/
        '';
      })
      
    ]; 
  };
}

