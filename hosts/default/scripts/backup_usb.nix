{ pkgs}:

pkgs.writeShellScriptBin "backup_usb.sh" '' 
#!/bin/sh
cp -rf ~/backup /run/media/$USER/yaros_usb/$USER_backup
''
