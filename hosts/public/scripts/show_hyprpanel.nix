{ pkgs}:

pkgs.writeShellScriptBin "show_hyprpanel.sh" '' 
#!/usr/bin/env bash

monitor=$(( $(hyprctl activeworkspace -j | jq '.id') < 11 ? 0 : 1 ))

if [[ "$(hyprpanel iwv bar-$monitor)" == "false" ]]; then
    hyprpanel t bar-$monitor
fi
''
