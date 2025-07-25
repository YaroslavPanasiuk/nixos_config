{ pkgs }:

pkgs.writeShellScriptBin "hyprtasking_toggle.sh" '' 
#!/usr/bin/env bash

echo "active" > /tmp/hyprtasking_status
sleep 0.05
hyprctl dispatch hyprtasking:if_not_active exec "echo 'inactive' > /tmp/hyprtasking_status"
sleep 0.05
hyprctl dispatch hyprtasking:if_active exec "echo 'active' > /tmp/hyprtasking_status"
sleep 0.05

if [ "$(cat /tmp/hyprtasking_status)" == "inactive" ]; then
    hyprctl keyword decoration:blur:enabled false
    hyprctl keyword decoration:inactive_opacity 1
    hyprctl dispatch hyprtasking:toggle cursor
    echo 'active' > /tmp/hyprtasking_status

    while true; do
        hyprctl dispatch hyprtasking:if_not_active exec "echo 'inactive' > /tmp/hyprtasking_status"
        sleep 0.1
        if [ "$(cat /tmp/hyprtasking_status)" == "inactive" ]; then
            hyprctl keyword decoration:blur:enabled true
            hyprctl keyword decoration:inactive_opacity 0.85
            break
        fi
    done
else
    hyprctl dispatch hyprtasking:toggle cursor
fi

''
