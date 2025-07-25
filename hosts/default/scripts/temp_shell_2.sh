#!/usr/bin/env bash

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