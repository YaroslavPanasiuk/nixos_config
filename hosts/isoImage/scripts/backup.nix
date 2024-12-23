{ pkgs}:

pkgs.writeShellScriptBin "backup.sh" '' 
#!/bin/sh

rm -rf ~/backup
mkdir -m 777 ~/backup
cp ~/.bashrc ~/backup
cp -rf ~/.cache/wal ~/backup
cp -rf ~/.cache/walogram ~/backup
cp -rf /etc/nixos ~/backup
cp -rf ~/.config ~/backup
cp -rf ~/Documents ~/backup
cp -rf ~/shared/Projects/sddm-sugar-dark ~/backup
cd ~/backup
git init
git add .
git commit -m "message"
git remote add origin git@github.com:YaroslavPanasiuk/nixos_backup.git
git push -f origin master
''
