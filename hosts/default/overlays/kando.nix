self: super: {
  zerotierone = super.zerotierone.overrideAttrs (old: {
    version = "1.10.6"; # Version from 23.11
    src = super.fetchFromGitHub {
      owner = "zerotier";
      repo = "ZeroTierOne";
      rev = "1.10.6";
      hash = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=";
    };
  });
  
  zerotier-service = super.callPackage ({ stdenv, zerotierone }: 
    (import (super.fetchTarball "https://github.com/NixOS/nixpkgs/archive/23.11.tar.gz") {})
      .zerotierone.overrideAttrs (old: {
        inherit (self.zerotierone) version src;
      })
  ) {};
}