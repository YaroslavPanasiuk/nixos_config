{ pkgs }:

pkgs.writeShellScriptBin "wallp-rofi.sh" '' 
dir="$HOME/Public/Wallpapers/"
image="$(for a in "$dir"*.jpg; do echo -en "''${a##*/}\0icon\x1f$a\n" ; done | sort -n | rofi -dmenu -config ~/.config/rofi/wallp-config.rasi)"
if [ -z "$image" ]; then
    return
fi
wallp.sh "$image"
''
