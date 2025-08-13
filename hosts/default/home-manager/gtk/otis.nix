{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "otis-theme";
  src = pkgs.fetchFromGitHub {
    owner = "EliverLara";
    repo = "otis";
    rev = "4757573983df6274b4c10f091b4dc7155e3771b7"; # Commit hash
    sha256 = "sha256-7OsupGTUpUL0mocQD48eKwvd97uEdZUzGk/HQFeL4MI="; # Temporary placeholder
  };
  installPhase = ''
    mkdir -p $out/share/themes
    cp -r $src $out/share/themes/Otis
  '';
}