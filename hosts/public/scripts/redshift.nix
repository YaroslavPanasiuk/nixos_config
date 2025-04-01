{ pkgs }:

pkgs.writeShellScriptBin "redshift.sh" '' 
#!/bin/sh
if pidof -qx "hyprsunset"; then
 	pkill hyprsunset
 	exit
fi
hyprsunset -t 4000
''
