{ ... }:
{  
  programs.git = {
    enable = true;
    userName  = "YaroslavPanasiuk";
    userEmail = "yaroslav.panasiuk@lnu.edu.ua";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}