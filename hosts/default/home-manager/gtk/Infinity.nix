{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "infinity";
  src = pkgs.fetchFromGitHub {
    owner = "L4ki";
    repo = "Infinity-Plasma-Themes";
    rev = "745e4543abf8de444b9381d5e8e0fe5f50296441";
    sha256 = "sha256-HMO6zL32qnwvcTLaWMyH3y5kYvbgQ0qIvyIqnFEnlq8=";
  };
  installPhase = ''
    mkdir -p $out/share/themes
    cp -r $src $out/share/themes/Infinity
  '';
}