{ pkgs }:

pkgs.writeShellScriptBin "waydroid_init.sh" '' 
#!/bin/sh
sudo waydroid init
git clone https://github.com/casualsnek/waydroid_script
cd waydroid_script
python3 -m venv venv
venv/bin/pip install -r requirements.txt
sudo venv/bin/python3 main.py install gapps libhoudini
start_waydroid.sh
sudo venv/bin/python3 main.py certified

''
