{ pkgs }:

pkgs.writeShellScriptBin "battery_reset.sh" '' 
#!/bin/sh
rm /home/yaros/Documents/battery_notifications 
touch /home/yaros/Documents/battery_notifications
''
