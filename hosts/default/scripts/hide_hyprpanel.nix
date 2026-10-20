{ pkgs}:

pkgs.writeShellScriptBin "hide_hyprpanel.sh" '' 
#!/usr/bin/env bash

monitor=$(( $(hyprctl activeworkspace -j | jq '.id') < 11 ? 0 : 1 ))

if [[ "$(hyprpanel iwv bar-$monitor)" == "true" ]]; then
    toggle_hyprpanel_visibility.sh
fi
''
