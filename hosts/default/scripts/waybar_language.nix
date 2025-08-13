{ pkgs }:

pkgs.writeShellScriptBin "waybar_language.sh" '' 
#!/usr/bin/env bash

layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.name == "at-translated-set-2-keyboard") | .active_keymap')
case "$layout" in
"Ukrainian")
	echo '{"text": "UA 🇺🇦", "class": "ua"}'
	;;
"English (US)"*)
	echo '{"text": "EN 🇺🇸", "class": "us"}'
	;;
*)
	short=$(echo "''${layout:0:2}" | tr '[:upper:]' '[:lower:]')
	echo "{\"text\": \"$short\", \"class\": \"other\"}"
	;;
esac

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
    [[ "$line" != "activelayout>>at-translated-set-2-keyboard"* ]] && continue

    case "$line" in
        *"Ukrainian"*)
            echo '{"text": "UA 🇺🇦", "class": "ua"}'
        ;;
        *"English"*)
            echo '{"text": "EN 🇺🇸", "class": "us"}'
        ;;
        
    esac
done

''
