{ pkgs }:

pkgs.writeShellScriptBin "stop_waydroid.sh" '' 
#!/bin/sh

waydroid session stop
systemctl stop waydroid-container
pkill Waydroid
''
