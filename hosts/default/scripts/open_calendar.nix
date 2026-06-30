{ pkgs }:

pkgs.writeShellScriptBin "open_calendar.sh" '' 
#!/bin/sh
xdg-open https://calendar.google.com/calendar/u/0/r
hyprctl dispatch "hl.dsp.focus({ window = 'class:zen-beta' })"
''
