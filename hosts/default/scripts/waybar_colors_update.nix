{ pkgs}:

pkgs.writeShellScriptBin "waybar_colors_update.sh" '' 
#!/usr/bin/env bash

update_waybar() {
    # Get active workspace ID
    active_ws=$(hyprctl activeworkspace -j | jq -r '.id')
    window_count=$(hyprctl clients -j | jq "map(select(.workspace.id == $(hyprctl activeworkspace -j | jq -r '.id')))" | jq "map(select(.floating == false)) | length")

    ignore_list=("kitty")
    ignored_count=0
    for item in "''${ignore_list[@]}"; do
        ((ignored_count = ignored_count + $(hyprctl clients | grep -c "class: $item")))
    done

    taskbar_border_line="#taskbar { border-left: 4px double @color15; }"
    if [ "$window_count" -eq 1 ]; then 
        taskbar_border_line="#taskbar { border-left: 2px solid @color1A; }" 
    fi
    if [ $(hyprctl clients | grep -c Window) -eq $ignored_count ]; then 
        taskbar_border_line="#taskbar { border-left: none; }" 
    fi

    focus="no"
    if [ "$window_count" -eq 1 ]; then
        focus="yes"
    fi
    if [ "$1" == "set_focus" ]; then
        focus="yes"
    fi
    if [ "$1" == "set_fancy" ]; then
        focus="no"
    fi

    if [ "$focus" == "yes" ]; then
        cat > /home/$USER/.cache/wal/waybar_css_mutable.css <<EOF
            @import "./gtk-theme.css";

            @define-color panel_background @backgrounds;
            @define-color panel_color1 @module_color2;
            @define-color panel_color2 @module_color4;
            @define-color module_color1 shade(@color1a, 0.5);
            @define-color module_color2 shade(@color3a, 0.5);
            @define-color module_color3 shade(@color5a, 0.5);
            @define-color module_color4 shade(@color7a, 0.4);
            @define-color module_color5 shade(@color9a, 0.5);

            .modules-left {
            border-right: none;
            border-top: none;
            border-bottom: none;
            margin: 1px 0px 1px 0px;
            }

            .modules-center {
            border: none;
            margin: 1px 5px 1px 5px;
            }

            .modules-right {
            border-left: none;
            border-top: none;
            border-bottom: none;
            margin: 1px 0px 1px 0px;
            }

            #workspaces { border-left: 2px solid @color1A; border-right: 2px solid @color1A; }
            #custom-timer { border-left: 2px solid @color1A; }
            #mpris { border-left: 2px solid @color1A; }
            $taskbar_border_line
            #tray { border-right: 2px solid @color1A; }
            #custom-language { border-right: 2px solid @color1A; }
            #custom-weather { border-right: 2px solid @color1A; }

EOF

    hyprctl keyword decoration:inactive_opacity 1
    hyprctl keyword decoration:blur:enabled false
    hyprctl keyword general:gaps_out 0
    hyprctl keyword general:gaps_in 0
    hyprctl keyword general:border_size 0
    hyprctl keyword decoration:rounding 0
        
    else
        cat > /home/$USER/.cache/wal/waybar_css_mutable.css <<EOF
            @import "./gtk-theme.css";

            @define-color panel_background rgba(0, 0, 0, 0);
            @define-color panel_color1 rgba(0, 0, 0, 0);
            @define-color panel_color2 rgba(0, 0, 0, 0);
            @define-color module_color1 @color1a;
            @define-color module_color2 @color3a;
            @define-color module_color3 @color5a;
            @define-color module_color4 shade(@color7a, 0.7);
            @define-color module_color5 @color9a;

            .modules-left {
            border-right: 2px solid @color15;
            border-top: 2px solid @color15;
            border-bottom: 2px solid @color15;
            margin: 4px 0px 0px 0px;
            }

            .modules-center {
            border: 2px solid @color15;
            margin: 4px 5px 0px 5px;
            }

            .modules-right {
            border-left: 2px solid @color15;
            border-top: 2px solid @color15;
            border-bottom: 2px solid @color15;
            margin: 4px 0px 0px 0px;
            }

            #workspaces { border-left: 4px double @color15; border-right: 4px double @color15; }
            #custom-timer { border-left: 4px double @color15; }
            #mpris { border-left: 4px double @color15; }
            $taskbar_border_line
            #tray { border-right: 4px double @color15; }
            #custom-language { border-right: 4px double @color15; }
            #custom-weather { border-right: 4px double @color15; }

EOF

    hyprctl keyword decoration:inactive_opacity 0.85
    hyprctl keyword decoration:blur:enabled true
    hyprctl keyword general:gaps_out 5
    hyprctl keyword general:gaps_in 3
    hyprctl keyword general:border_size 2
    hyprctl keyword decoration:rounding 8
    fi
    # Reload Waybar
}

if [ "$1" == "update" ]; then
    update_waybar
    exit
fi

if [ "$1" == "set_focus" ]; then
    update_waybar "set_focus"
    exit
fi

if [ "$1" == "set_fancy" ]; then
    update_waybar "set_fancy"
    exit
fi

# Monitor workspace and window events
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
    event_type="''${line%>>*}"

    [[ "$event_type" != @("workspace"|"openwindow"|"closewindow"|"movewindow") ]] && continue
    
    if [[ $line == *"kando"* || $line == *",,"* || $line == *"Gimp,GNU Image Manipulation Program"* ]] ||
       { [[ "$event_type" == "openwindow" ]] && hyprctl activewindow | grep -q "floating: 1"; }; then
        continue
    fi
    update_waybar
done

''
