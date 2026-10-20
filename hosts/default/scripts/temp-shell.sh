#!/usr/bin/env bash

layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap')

if [ "$ROFI_RETV" = "1" ]; then
    echo -n "$1" | wl-copy
    exit 0
fi

if [ -z "$1" ]; then
    echo "Start typing to translate..."
    exit 0
fi

set=0
if [[ "$layout" == 'Ukrainian' ]]; then 
    source="uk"
    dest="en"
fi
if [[ "$layout" == 'English (US)' ]]; then 
    source="en"
    dest="uk"
fi

if [[ ! "$1" == *[[:space:]]* ]]; then
    trans -no-ansi -no-theme "$source:$dest" "$1" 2>/dev/null | awk '/^ {4}[^ ]/ {
        sub(/^ +/, "")
        lines[++count] = $0
    }
    END {
        if (count > 0) {
            print lines[count]
            for (i = 1; i < count; i++) {
                print lines[i]
            }
        }
    }'
    exit 0
fi

trans -b "$source:$dest" "$1" 2>/dev/null
