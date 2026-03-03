{ ... }:
{  
  programs.git = {
    enable = true;
    settings = {
      user.name = "YaroslavPanasiuk";
      user.email = "yaroslav.panasiuk@lnu.edu.ua";
      init.defaultBranch = "main";
    };
  };
}