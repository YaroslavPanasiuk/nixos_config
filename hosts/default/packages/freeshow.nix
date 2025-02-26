{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "freeshow";
  version = "1.3.8";

  # Fetch from GitHub
  src = pkgs.fetchFromGitHub {
    owner = "ChurchApps";
    repo = "FreeShow";
    rev = "v${version}"; # Git tag/commit hash
    sha256 = "0xch7cflgzyh58dxcgijy4zdm9j7sk5wsjp1bw3kyq6mav0f3lh5";
  };

  # Build dependencies
  nativeBuildInputs = [ pkgs.makeWrapper pkgs.cmake ]; # Example tools

  # Runtime dependencies
  buildInputs = [ pkgs.libfontconfig1-dev pkgs.zlib ]; # Example libraries

  # Configure/build commands (adjust for your project)
  configurePhase = ''
    cmake .
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./my-binary $out/bin/
  '';

  meta = {
    description = "Description of your package";
    homepage = "https://github.com/github-username/repo-name";
    license = pkgs.lib.licenses.mit; # Adjust license
  };
}