{ pkgs }:

pkgs.writeShellScriptBin "speed_read.sh" '' 
mode=$(echo -e "📋 From clipboard\n📂 From file" | rofi -dmenu -config ~/.config/rofi/config-waybar_mode.rasi)

case "$mode" in
    "📋 From clipboard")
        text=$(wl-paste)
        if [ -z "$text" ]; then
            notify-send "Clipboard is empty" -i dialog-error
            exit 1
        fi
    ;;
    "📂 From file")
        file=$(zenity --file-selection --title="Select a File" --file-filter="Text Files | *.txt *.pdf *.doc *.docx *.epub" )
        if [ -z "$file" ]; then
            notify-send "No file selected" -i dialog-error
            exit 1
        fi
        extension="''${file##*.}"
        case "$extension" in
            "txt")
                text=$(cat "$file")
            ;;
            "pdf")
                text=$(pdftotext "$file" -)
            ;;
            "doc"|"docx")
                text=$(pandoc -t plain "$file")
            ;;
            "epub")
                text=$(epub2txt2 "$file")
            ;;
            *)
                notify-send "Unsupported file type" -i dialog-error
                exit 1
            ;;
        esac
    ;;
esac
if [ -z "$text" ]; then
    exit 1
fi

tmp_text=$(mktemp)
echo "$text" > "$tmp_text"

kitty -o font_size=24 \
      -o window_padding_width=16\
      -o "modify_font cell_height 200%" \
      -o cursor_blink_interval=0 \
      --title "SpeedRead" \
      --class "speedread-float" \
      sh -c "printf '\e[?25l'; speedread -w 250 < $tmp_text; sleep 15; printf '\e[?25h'"

rm "$tmp_text"
''
