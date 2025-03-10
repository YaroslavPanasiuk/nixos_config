{ pkgs}:

pkgs.writeShellScriptBin "generate_ssh.sh" '' 
#!/usr/bin/env bash

ssh-keygen -t ed25519 -C "yaroslav.panasiuk@lnu.edu.ua"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub | wl-copy
cat ~/.ssh/id_ed25519.pub
xdg-open https://github.com/settings/keys

''
