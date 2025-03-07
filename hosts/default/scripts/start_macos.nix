{ pkgs }:

pkgs.writeShellScriptBin "start_macos.sh" '' 
#!/bin/sh

pkill qemu

quickemu --vm ~/virtual/macos-big-sur.conf --width 1920 --height 1080
''
