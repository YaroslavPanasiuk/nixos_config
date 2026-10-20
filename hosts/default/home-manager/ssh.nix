{ ... }:
{  
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
        "*" = {
            SendEnv = "LANG LC_*"; 
        };
        
        "lvivdeb" = {
            HostName = "92.253.238.166";
            User = "yaros";
            Port = "22022";
            IdentityFile = "~/.ssh/id_ed25519";
        };

        "drodeb" = {
            HostName = "100.113.11.199";
            User = "yaros";
            IdentityFile = "~/.ssh/id_ed25519";
        };
    };
  };
}