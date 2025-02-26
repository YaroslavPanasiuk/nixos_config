{ pkgs}:

pkgs.writeShellScriptBin "export_images.sh" '' 
#!/usr/bin/env bash
path=$1
filename=$(basename $path)
filename_no_ext=''${filename%.*}
extension=''${filename##*.}
dir=$(dirname $path)
extension=''${filename##*.}

if [[ "$extension" != "pdf" ]]; then
    soffice --headless --convert-to pdf $filename
fi
mkdir $filename_no_ext"_"$extension
pdftoppm -png -r 96 "$filename_no_ext.pdf" "./$filename_no_ext"_pptx"/$filename_no_ext"

if [[ "$extension" != "pdf" ]]; then
    rm -f $filename_no_ext.pdf
fi
''
