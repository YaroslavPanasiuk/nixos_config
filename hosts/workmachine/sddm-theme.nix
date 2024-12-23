{pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = builtins.path {
    path = /home/yaros/shared/Projects/sddm-sugar-dark;
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
  '';
}
