{ stdenvNoCC }:
stdenvNoCC.mkDerivation {
  name = "my-plymouth-theme";
  src = ./my-theme; # Path to your theme files
  installPhase = ''
    mkdir -p $out/share/plymouth/themes/my-theme
    cp -r $src/* $out/share/plymouth/themes/my-theme
  '';
}