{ pkgs }:

pkgs.writeShellScriptBin "battery_reset.sh" '' 
#!/bin/sh
rm /home/yaros/.config/systemd/user/temp.txt
touch /home/yaros/.config/systemd/user/temp.txt
''
