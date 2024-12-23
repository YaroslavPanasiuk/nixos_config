{ pkgs }:

pkgs.writeShellScriptBin "poweroff" "echo 1 | sudo -S shutdown -h now"
