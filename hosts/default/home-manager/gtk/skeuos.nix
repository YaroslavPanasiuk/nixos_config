{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "skeuos";
  src = ./Otis;  # Path to your local theme directory
  installPhase = ''
    mkdir -p $out/share/themes
    cp -r $src $out/share/themes/Skeuos  # Replace with your theme's folder name
  '';
}