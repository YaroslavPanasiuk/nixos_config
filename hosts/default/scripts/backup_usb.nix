{ pkgs}:

pkgs.writeShellScriptBin "backup_usb.sh" '' 
#!/bin/sh
cp -rf ~/backup /run/media/yaros/yaros_usb/yaros_backup
''
