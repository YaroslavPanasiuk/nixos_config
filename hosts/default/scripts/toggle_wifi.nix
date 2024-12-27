{ pkgs }:

pkgs.writeShellScriptBin "toggle_wifi.sh" '' 
#!/bin/sh

# Check the current status of Wi-Fi
STATUS=$(nmcli radio wifi)

if [ "$STATUS" = "enabled" ]; then
  # Disable Wi-Fi if it's enabled
  nmcli radio wifi off
  echo "Wi-Fi disabled"
else
  # Enable Wi-Fi if it's disabled
  nmcli radio wifi on
  echo "Wi-Fi enabled"
fi

''
