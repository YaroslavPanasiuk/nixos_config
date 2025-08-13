{ config, pkgs, ... }:
let
  otis = import ./otis.nix { inherit pkgs; };
  infinity = import ./Infinity.nix { inherit pkgs; };
in
{
  gtk = {
	enable = true;
	theme = {
      name = "Juno-mirage-v40";
      package = pkgs.juno-theme;
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
