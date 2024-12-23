{ pkgs }:

pkgs.writeShellScriptBin "stop_waydroid.sh" '' 
#!/bin/sh

waydroid session stop
echo 1 | sudo -S systemctl stop waydroid-container
pkill Waydroid
''
