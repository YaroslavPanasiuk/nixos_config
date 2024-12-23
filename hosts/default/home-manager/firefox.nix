{ pkgs, inputs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default = {

      search.force = true;

      bookmarks = [
        {
          name = "mail";
          tags = [ "mail" ];
          keyword = "proton";
          url = "https://mail.proton.me/u/0/inbox";
        }
        {
          name = "";
          tags = [ "mail" ];
          keyword = "gmail";
          url = "https://mail.google.com/mail/u/1/#inbox";
        }
        {
          name = "";
          tags = [ "nixos" ];
          keyword = "nixos";
          url = "https://search.nixos.org/packages?channel=24.11&from=0&size=50&sort=relevance&type=packages";
        }
        {
          name = "";
          tags = [ "chatgpt" ];
          keyword = "chatgpt";
          url = "https://chatgpt.com/";
        }
        {
          name = "";
          tags = [ "github" ];
          keyword = "github";
          url = "https://github.com/";
        }
        {
          name = "";
          tags = [ "spreadsheets" ];
          keyword = "spreadsheets";
          url = "https://docs.google.com/spreadsheets/u/1/";
        }
        {
          name = "";
          tags = [ "youtube" ];
          keyword = "youtube";
          url = "https://www.youtube.com/";
        }
        {
          name = "";
          tags = [ "music" ];
          keyword = "youtube";
          url = "https://music.youtube.com/";
        }
        {
          name = "";
          tags = [ "anitube" ];
          keyword = "anitube";
          url = "https://anitube.in.ua/anime/";
        }
        {
          name = "";
          tags = [ "maps" ];
          keyword = "maps";
          url = "https://www.google.com/maps";
        }
      ];

    };
  };

}