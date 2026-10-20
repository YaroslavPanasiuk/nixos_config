{ lib, pkgs }:
pkgs.stdenv.mkDerivation {
  name = "nixos-plymouth-theme";
  src = ./.;
  installPhase = ''
    mkdir -p $out/share/plymouth/themes/nixos-logo
    cp ${./logo.png} $out/share/plymouth/themes/nixos-logo/logo.png
    cat > $out/share/plymouth/themes/nixos-logo/nixos-logo.plymouth <<EOF
    [Plymouth Theme]
    Name=NixOS Logo
    Description=A theme featuring the NixOS logo
    ModuleName=script

    [script]
    ImageDir=$out/share/plymouth/themes/nixos-logo
    ScriptFile=$out/share/plymouth/themes/nixos-logo/nixos-logo.script
    EOF

    cat > $out/share/plymouth/themes/nixos-logo/nixos-logo.script <<EOF
    wallpaper_image=Image("logo.png");
    screen_width=Window.GetWidth();
    screen_height=Window.GetHeight();
    logo_width=wallpaper_image.GetWidth();
    logo_height=wallpaper_image.GetHeight();
    logo_x=(screen_width - logo_width)/2;
    logo_y=(screen_height - logo_height)/2;
    wallpaper_image.SetPosition(logo_x, logo_y, 0);
    EOF
    '';
}