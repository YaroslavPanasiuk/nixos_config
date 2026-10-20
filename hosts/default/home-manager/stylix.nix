{ pkgs, inputs, ... }:

{
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];
  
  stylix = {
    enable = true;
    image = ./extra_resources/Wallpaper.jpg;
    polarity = "dark";

    cursor = {
      package = pkgs.volantes-cursors;
      name = "volantes_cursors";
      size = 24;
    };

    iconTheme = {
      package = pkgs.kora-icon-theme;
      dark = "kora";
      light = "kora";
      enable = true;
    };

    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 10;
        desktop = 11;
        popups = 11;
        terminal = 11;
      };
    };

    targets = {
      hyprland.enable = false;   
      waybar.enable = false;   
      gtk.enable = false;   
      helix.enable = false;   
      zellij.enable = false;   
      zathura.enable = false;   
      yazi.enable = false;   
      wpaperd.enable = false;   
      wofi.enable = false;   
      wob.enable = false;   
      wezterm.enable = false;   
      vscode.enable = false;   
      vim.enable = false;   
      vesktop.enable = false;   
      tofi.enable = false;   
      tmux.enable = false;   
      sxiv.enable = false;   
      swaylock.enable = false;   
      hyprlock.enable = false;   
      spicetify.enable = false;   
      rofi.enable = false;   
      river.enable = false;   
      qutebrowser.enable = false;   
      nushell.enable = false;   
      nixvim.enable = false;   
      neovim.enable = false;   
      ncspot.enable = false;   
      mako.enable = false;   
      mangohud.enable = false;   
      librewolf.enable = false;   
      lazygit.enable = false;   
      kubecolor.enable = false;   
      kitty.enable = false;   
      gedit.enable = false;   
      fuzzel.enable = false;   
      fzf.enable = false;   
      forge.enable = false;   
      foot.enable = false;   
      fish.enable = false;   
      firefox.enable = false;   
      feh.enable = false;   
      emacs.enable = false;   
      dunst.enable = false;   
    };
  };
}
