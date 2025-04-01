{ pkgs }:

pkgs.writeShellScriptBin "restart" "echo 1 | sudo -S reboot -h now"
