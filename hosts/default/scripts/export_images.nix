{ pkgs}:

pkgs.writeShellScriptBin "export_images.sh" '' 
#!/usr/bin/env bash


for path in "$@"; do
    filename=$(basename "$path")
    filename_no_ext=''${filename%.*}
    extension=''${filename##*.}
    dir=$(dirname "$path")

    if [[ "$extension" != "pdf" ]]; then
        echo "$dir/$filename_no_ext.pdf"
        soffice --headless --convert-to pdf --outdir "$dir" "$dir/$filename"
    fi
    rm -rf "$dir/$filename_no_ext"_"$extension"
    mkdir "$dir/$filename_no_ext"_"$extension"
    pdftoppm -png -r 96 "$dir/$filename_no_ext.pdf" "$dir/$filename_no_ext"_"$extension/$filename_no_ext"

    if [[ "$extension" != "pdf" ]]; then
        rm -f "$dir/$filename_no_ext.pdf"
    fi
done

notify-send -t 5000 "Exporting images" "Successfully exported images to $dir/$filename_no_ext"_"$extension"

''
