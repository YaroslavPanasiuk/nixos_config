{ pkgs }:

pkgs.writeShellScriptBin "select_adb_device.sh" '' 
#!/usr/bin/env bash
mapfile -t my_list < <(adb devices -l | sed '1d')
model=$(for a in "''${my_list[@]}"; do echo $a | awk '{print $5}' ; done | rofi -dmenu -config ~/.config/rofi/config-lang.rasi)

for item in "''${my_list[@]}"; do
    if [[ "$item" == *"$model"* ]]; then
        serial_num=$(echo "$item" | awk '{print $1}')
        break
    fi
done

echo $serial_num
''
