{ config, pkgs, inputs, ... }:

{
  gtk = {
	  enable = true;
    theme = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme;
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