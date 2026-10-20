{ pkgs ? import <nixpkgs> {} }:

let
  inherit (pkgs) lib stdenv buildGoModule fetchFromGitHub makeWrapper pkg-config gtk3 wayland gtk-layer-shell;
  configDir = "$HOME/.config/hypr-dock";
in buildGoModule rec {
  pname = "hypr-dock";
  version = "1.1.0";  # Update with your version

  src = fetchFromGitHub {
    owner = "lotos-linux";
    repo = "hypr-dock";
    rev = "v${version}";
    sha256 = "sha256-sTFR/eVln5YPuNjFTGudMPnFsQGgwU8dtPQSJPAmTTo=";
  };

  vendorHash = "sha256-X/0dJzJQ9xaS+oXOqltvMXh8eSS7MAkINBxf22+jUDg=";

  nativeBuildInputs = [ makeWrapper pkg-config ];
  buildInputs = [ gtk3 wayland gtk-layer-shell ];

  env.CGO_ENABLED = "1";
  
  buildPhase = ''
    make build
  '';

  installPhase = ''
    mkdir -p $out/bin

    install -Dm755 bin/${pname} $out/bin/${pname}

    mkdir -p $out/share/${pname}/configs
    cp -r configs/* $out/share/${pname}/configs

    makeWrapper $out/bin/${pname} $out/bin/.${pname}-wrapped \
      --run "mkdir -p ${configDir}" \
      --run "[ -d ${configDir} ] && [ ! -f ${configDir}/config.json ] && cp $out/share/${pname}/configs/* ${configDir}/ || true"

    mv $out/bin/.${pname}-wrapped $out/bin/${pname}
  '';
}