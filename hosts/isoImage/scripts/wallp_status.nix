{ pkgs }:

pkgs.writeShellScriptBin "wallp_status.sh" '' 
#!/bin/sh
#status=$(bluetoothctl show | grep "Powered: yes")

if [pgrep -fl post_setting.sh &>/dev/null]; then
    echo "++"  # Bluetooth off icon
else
    echo "$(pgrep -fl post_setting.sh)"  # Bluetooth on icon
fi
''
