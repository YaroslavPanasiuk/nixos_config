{ pkgs}:

pkgs.writeShellScriptBin "toggle_hyprpanel_visibility.sh" '' 
#!/usr/bin/env bash

monitor=$(( $(hyprctl activeworkspace -j | jq '.id') < 11 ? 0 : 1 ))

case "$1" in
    "show")
        if [[ "$(hyprpanel iwv bar-$monitor)" == "true" ]]; then
            exit
        fi
        ;;
    "hide")
        if [[ "$(hyprpanel iwv bar-$monitor)" == "false" ]]; then
            exit
        fi
        ;;
    "unactive")
        monitor=$(( $monitor == 1 ? 0 : 1 ))
        ;;
    "query")
        [ "$(hyprpanel iwv bar-$monitor)" = "true" ] && echo "true" || echo "false"
        exit
        ;;
    *)
        hyprpanel t bar-$monitor
        exit
        ;;
esac

hyprpanel t bar-$monitor
''
