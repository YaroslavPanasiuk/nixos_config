{ pkgs }:

pkgs.writeShellScriptBin "select_adb_device.sh" '' 
#!/usr/bin/env bash
#!/usr/bin/env bash
mapfile -t my_list < <(adb devices -l | sed '1d' | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}')
csv_data=$(curl -s http://storage.googleapis.com/play_public/supported_devices.csv | iconv -f UTF-16LE -t UTF-8)

new_list=()
for item in "''${my_list[@]}"; do
    model_code=$(echo "$item" | awk '{print substr($5, 7)}')
    commercial_name=$(echo "$csv_data" | grep -i "$model_code" | head -n 1 | cut -d, -f2)
    new_list+=("$item $commercial_name")
done

if [ ''${#my_list[@]} -eq 0 ]; then
    notify-send -t 5000 "ADB device selection" "No devices attached"
    exit 1
fi

if [ ''${#my_list[@]} -eq 1 ]; then
    echo "''${my_list[0]}" | awk '{print $1}'
    exit
fi

name=$(for a in "''${new_list[@]}"; do echo $a | grep -o '"[^"]*"' | tr -d '"' | tail -n 1 ; done | rofi -dmenu -config ~/.config/rofi/config-lang.rasi)

for item in "''${new_list[@]}"; do
    if [[ "$item" == *"$name"* ]]; then
        serial_num=$(echo "$item" | awk '{print $1}')
        break
    fi
done

echo $serial_num


''
