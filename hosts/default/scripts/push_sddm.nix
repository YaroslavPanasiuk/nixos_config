{ pkgs }:

pkgs.writeShellScriptBin "push_sddm.sh" '' 
#!/bin/sh

cd ~/shared/Projects/sddm-sugar-dark
git add .
git commit -m "wallp change"
git push -f origin master

out=""
while [ $out="" ]
do
  out=$(nix-prefetch-git https://github.com/YaroslavPanasiuk/sddm-panas.git)
  echo retrying...
done

echo $out

rev=$(echo $out | awk '{ print substr($5, 1, length($5)-1) }')
sha256=$(echo $out | awk '{print substr($11, 1, length($11)-1)}')

echo "rev = ''${rev}"
echo "sha256 = ''${sha256}"

echo 1 | sudo -S sed -i "/rev = /c\rev = ''${rev};" /etc/nixos/sddm-theme.nix
echo 1 | sudo -S sed -i "/sha256 = /c\sha256 = ''${sha256};" /etc/nixos/sddm-theme.nix
''
