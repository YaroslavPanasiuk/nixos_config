{ pkgs}:

pkgs.writeShellScriptBin "convert_presentation.sh" '' 
#!/usr/bin/env bash

final_extension=$1

shift

for path in "$@"; do
    filename=$(basename "$path")
    filename_no_ext=''${filename%.*}
    extension=''${filename##*.}
    dir=$(dirname "$path")

    case "$extension-$final_extension" in
        pdf-pdf|pptx-pptx|odp-odp|key-key)
            continue
        ;;
        pdf-pptx)
            notify-send -t 5000 "Create PowerPoint" "Starting creating Powerpoint presentation..."
        
            cd ~/nixos/hosts/default/scripts/python
            source ./venv/bin/activate
            nix-shell --run "python pdf_to_pptx.py --input_pdf '$dir/$filename_no_ext.pdf' --output_pptx '$dir/$filename_no_ext.pptx'"
            
            notify-send -t 5000 "Create PowerPoint" "Successfully created Powerpoint presentation at $dir/$filename_no_ext.pptx"
        ;;
        pdf-odp)
            notify-send -t 5000 "Create odp" "Starting creating LibreOffice Impress presentation..."
            cd ~/nixos/hosts/default/scripts/python
            notify-send -t 5000 "Create PowerPoint" "Starting creating Powerpoint presentation..."
        
            cd ~/nixos/hosts/default/scripts/python
            source ./venv/bin/activate
            nix-shell --run "python pdf_to_pptx.py --input_pdf '$dir/$filename_no_ext.pdf' --output_pptx '$dir/$filename_no_ext.pptx'"
            
            soffice --headless --convert-to odp --outdir "$dir" "$dir/$filename_no_ext.pptx"
            notify-send -t 5000 "Create odp" "Successfully created LibreOffice Impress presentation at $dir/$filename_no_ext.odp"
        ;;
        key-pptx|odp-pptx)
            soffice --headless --convert-to pptx --outdir "$dir" "$dir/$filename"
            notify-send -t 5000 "Create PowerPoint" "Successfully created Powerpoint presentation at $dir/$filename_no_ext.pptx"
        ;;
        key-odp|pptx-odp)
            soffice --headless --convert-to odp --outdir "$dir" "$dir/$filename"
            notify-send -t 5000 "Create odp" "Successfully created LibreOffice Impress presentation at $dir/$filename_no_ext.odp"
        ;;
        pptx-pdf|key-pdf|odp-pdf)
            notify-send -t 5000 "Create PDF" "Starting creating PDF from presentation..."
            soffice --headless --convert-to pdf --outdir "$dir" "$dir/$filename"
            notify-send -t 5000 "Create PDF" "Successfully created PDF from presentation at $dir/$filename_no_ext.pdf"
        ;;
    esac

done


''
