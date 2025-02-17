{ pkgs, ... }:
{  
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
    (stdenv.mkDerivation {
      name = "ttnorms-bold";
      src = ../fonts/ttnorms;
      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp $src/*.ttf $out/share/fonts/truetype/
      '';
    })
  ]; 
}