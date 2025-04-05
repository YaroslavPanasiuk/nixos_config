{ pkgs, ... }: {
  nixpkgs.config.packageOverrides = pkgs: {
    kando = pkgs.kando.overrideAttrs (oldAttrs: {
      version = "1.8.0";
      src = pkgs.fetchFromGitHub {
        owner = "kando-menu";
        repo = "kando";
        rev = "35b62134ee77c67c09686dee23258dfd87b0254c";
        sha256 = "sha256-t96EmoQwaWwYSKSiLdciS7hsFw0IjHGiDqZnf79sxXk=";
      };
      npmDepsHash = "sha256-lyCIuvyoVhcrNDDg0P3lSY8ru81momG1EKKT5u4yW8Y=";
    });
  };
}