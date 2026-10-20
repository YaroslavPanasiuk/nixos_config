{ pkgs}:

pkgs.writeShellScriptBin "backup.sh" '' 
#!/bin/sh

read -p "Which branch to push? ('m' - main, 'l' - legion): " branch

sed -i "s/$USER/__user__/g" ~/nixos/hosts/default/configuration_modules/user.nix

cd ~/nixos

if [ $branch == 'm' ]; then
    git switch main
    git add .
    git commit -m "message"
    git push -f origin main
elif [ $branch == 'l' ]; then
    git switch legion
    git add .
    git commit -m "message"
    git push -f origin legion
fi

sed -i "s/__user__/$USER/g" ~/nixos/hosts/default/configuration_modules/user.nix


''
