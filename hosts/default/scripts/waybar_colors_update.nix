{ pkgs}:

pkgs.writeShellScriptBin "waybar_colors_update.sh" '' 
#!/usr/bin/env bash

update_waybar() {
    # Get active workspace ID
    active_ws=$(hyprctl activeworkspace -j | jq -r '.id')
    # Count windows in active workspace
    window_count=$(hyprctl clients -j | jq "map(select(.workspace.id == $active_ws)) | length")
    
    # Set Waybar color based on window count
    if [ "$window_count" -eq 1 ]; then
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
            }

            .modules-center {
            border: none;
            }

            .modules-right {
            border-left: none;
            border-top: none;
            border-bottom: none;
            }

            #workspaces { border-left: 2px solid @color1A; border-right: 2px solid @color1A; }
            #taskbar { border-left: 2px solid @color1A; }
            #mpris { border-left: 2px solid @color1A; }
            #tray { border-right: 2px solid @color1A; }
            #language { border-right: 2px solid @color1A; }
            #custom-weather { border-right: 2px solid @color1A; }

EOF
        
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
            border-right: 2px solid shade(@cursor, 0.7);
            border-top: 2px solid shade(@cursor, 0.7);
            border-bottom: 2px solid shade(@cursor, 0.7);
            }

            .modules-center {
            border: 2px solid shade(@cursor, 0.7);
            }

            .modules-right {
            border-left: 2px solid shade(@cursor, 0.7);
            border-top: 2px solid shade(@cursor, 0.7);
            border-bottom: 2px solid shade(@cursor, 0.7);
            }

            #workspaces { border-left: 4px double shade(@cursor, 0.7); border-right: 4px double shade(@cursor, 0.7); }
            #taskbar { border-left: 4px double shade(@cursor, 0.7); }
            #mpris { border-left: 4px double shade(@cursor, 0.7); }
            #tray { border-right: 4px double shade(@cursor, 0.7); }
            #language { border-right: 4px double shade(@cursor, 0.7); }
            #custom-weather { border-right: 4px double shade(@cursor, 0.7); }

EOF
    fi
    # Reload Waybar
}

# Monitor workspace and window events
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
    case ''${line%>>*} in
        "workspace"|"openwindow"|"closewindow"|"movewindow")        
            echo $line | grep "kando" && continue
            echo $line | grep "openwindow" && hyprctl activewindow | grep -q "floating: 1" && continue
            
            update_waybar
            ;;
    esac
done
''
