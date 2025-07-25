{ pkgs}:

pkgs.writeShellScriptBin "images_to_pptx.sh" '' 
#!/usr/bin/env bash

output_file=""
images=""
INPUTS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -o) output_file="$2"; shift 2;;
        -i) shift; while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
                INPUTS+=("$1")
                shift
            done ;;
        *) echo "Unknown option: $1"; exit 1;;
    esac
done

if [ -z "$output_file" ]; then
    output_file=$(dirname "''${INPUTS[0]}")/$(basename "$(dirname "''${INPUTS[0]}")").pptx
fi

cd ~/nixos/hosts/default/scripts/python
source ./venv/bin/activate

    for path in "''${INPUTS[@]}"; do
        images="$images$path;;"
    done


python images_to_pptx.py --images "$images" --output "$output_file"
notify-send -t 5000 "Create PowerPoint" "Successfully created Powerpoint presentation at $output_file"
''
