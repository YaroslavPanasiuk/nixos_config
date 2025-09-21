self: super: {
  zerotierone = super.zerotierone.overrideAttrs (old: {
    version = "1.10.6";
    src = super.fetchFromGitHub {
      owner = "zerotier";
      repo = "ZeroTierOne";
      rev = "1.10.6";
      hash = "sha256-mapFKeF+8jMGkxSuHaw5oUdTdSQgAdxEwF/S6iyVLbY=";
    };
  });
}