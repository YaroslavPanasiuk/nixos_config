{ config, pkgs, ... }:
let
  otis = import ./otis.nix { inherit pkgs; };
  infinity = import ./Infinity.nix { inherit pkgs; };
  skeuos = import ./skeuos.nix { inherit pkgs; };
in
{
  gtk = {
	enable = true;
	theme = {
      name = "Skeuos";
      package = skeuos;
    };
  gtk3.theme = {
      name = "Skeuos";
      package = skeuos;
    };
  gtk4.theme = {
      name = "Skeuos";
      package = skeuos;
    };
	cursorTheme = {
	  name = "volantes_cursors";
	  package = pkgs.volantes-cursors;
	};
	iconTheme = {
	  name = "kora";
	  package = pkgs.kora-icon-theme;
	};
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };
}
