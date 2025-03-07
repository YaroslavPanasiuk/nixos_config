{ pkgs}:

pkgs.writeShellScriptBin "images_to_pptx.sh" '' 
#!/usr/bin/env bash

cd ~/nixos/hosts/default/scripts/python
source ./venv/bin/activate

python images_to_pptx.py --folder "$1" --output "$1/presentation.pptx"

notify-send -t 5000 "Create PowerPoint" "Successfully created Powerpoint presentation at $1/presentation.pptx"
''
