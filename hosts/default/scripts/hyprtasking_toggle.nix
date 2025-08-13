{ pkgs }:

pkgs.writeShellScriptBin "hyprtasking_toggle.sh" '' 
#!/usr/bin/env bash

hyprctl dispatch hyprtasking:if_not_active exec "hyprctl dispatch hyprtasking:toggle cursor"
echo "active" > /tmp/hyprtasking_status
sleep 0.01
hyprctl dispatch hyprtasking:if_not_active exec "echo 'inactive' > /tmp/hyprtasking_status"
sleep 0.01
hyprctl dispatch hyprtasking:if_active exec "echo 'active' > /tmp/hyprtasking_status"
sleep 0.01

if [ "$(cat /tmp/hyprtasking_status)" == "active" ]; then
    initial_opacity=$(hyprctl getoption decoration:inactive_opacity | awk 'NR==1 {print $2}')
    initial_blur=$(hyprctl getoption decoration:blur:enabled | awk 'NR==2 {print $2}')
    hyprctl keyword decoration:blur:enabled false
    hyprctl keyword decoration:inactive_opacity 1
    echo 'active' > /tmp/hyprtasking_status

    while true; do
        hyprctl dispatch hyprtasking:if_not_active exec "echo 'inactive' > /tmp/hyprtasking_status"
        sleep 0.05
        if [ "$(cat /tmp/hyprtasking_status)" == "inactive" ]; then
            hyprctl keyword decoration:blur:enabled $initial_blur
            hyprctl keyword decoration:inactive_opacity $initial_opacity
            break
        fi
    done
fi

''