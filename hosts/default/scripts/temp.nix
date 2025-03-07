{ pkgs }:
let
  cargoTarball = pkgs.rustPlatform.fetchCargoTarball {
    src = pkgs.fetchFromGitHub {
      owner = "JakeStanger";
      repo = "ironbar";
      rev = "b90cf36fbffb2be4378f3aee921e01539cedee3e";
      hash = "0z117r63khm8fx1sypnkwm1rrsrqnj800if5h4vjia6ja19snbwc"; # Hash of the source code
    };
    hash = ""; # Leave empty to compute it
  };
in cargoTarball.cargoHash