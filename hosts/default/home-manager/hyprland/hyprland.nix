{ config, pkgs, inputs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    package = inputs.hyprland.packages.${pkgs.system}.hyprland; 

    plugins = [
      inputs.hyprtasking.packages.${pkgs.system}.hyprtasking
      #inputs.hyprgrass.packages.${pkgs.system}.hyprgrass-pulse
      #inputs.hyprgrass.packages.${pkgs.system}.default
      #inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      #inputs.hycov.packages.${pkgs.system}.hycov
    ];

    settings = {
      
      source = "$HOME/.cache/wal/colors-hyprland.conf";
      monitor = [
        ",preferred,auto,1"
        
      ];
      

      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$menu" = "set_layout.sh us && rofi -show drun";
      "$browser" = "zen";
      "$mainMod" = "SUPER";

      exec-once = [
        "hyprlock"
        "hypridle"
        "swww-daemon"
        "syshud &"
        "hyprctl setcursor volantes_cursors 24"
        "sleep 2 && hyprctl dispatch overview:close"
        "lxqt-policykit-agent"
        "systemctl --user start battery"
        "systemctl --user start battery_reset"
        "kando"
        "sleep 1 && waybar"
        "sleep 2 && hyprland_focus_modes.sh update"
        "sleep 3 && nm-applet"
        "sleep 5 && blueman-tray"
        "sleep 5 && blueman-applet"
        #"touchegg"
        "thunar --daemon"
        "wl-paste --watch cliphist store"
        "hyprswitch init --size-factor 4 --custom-css ~/.config/hyprswitch/hyprswitch.css"
      ];

      general = { 
        gaps_in = 2;
        gaps_out = 2;
        border_size = 2;
        "col.active_border" = "$color1 $color2 45deg"; #"rgb(${builtins.replaceStrings ["#"] [""] config.pywal-nix.colourScheme.colours.colour1}) rgb(${builtins.replaceStrings ["#"] [""] config.pywal-nix.colourScheme.colours.colour2}) 45deg";
        "col.inactive_border" = "$color15"; #"rgb(${builtins.replaceStrings ["#"] [""] config.pywal-nix.colourScheme.colours.colour15})";
        resize_on_border = "false";
        allow_tearing = "false";
        layout = "dwindle";
      };

      gestures = {
        # REMOVED: workspace_swipe = "true";
        workspace_swipe_distance = 1500;
        workspace_swipe_min_speed_to_force = 5;
        # REMOVED: workspace_swipe_min_fingers = "true"; 
        workspace_swipe_cancel_ratio = "0.1";
        workspace_swipe_direction_lock = false;
        workspace_swipe_invert = "true";
        workspace_swipe_create_new = "true";
        
        gesture = [
          "3, horizontal, workspace"
          "3, down, close"
          "3, up, dispatcher, exec, hyprtasking_toggle.sh"
        ];
      };

      animations = {
        enabled = "true";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 1, default"
          #"windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 7, default"
          "layersIn, 1, 3, default, popin 70%"
          "fadeLayersOut, 1, 5, default"
          
        ];
      };

      device = {
        name = "epic-mouse-v1";
        sensitivity = "-0.5";
      };  

      cursor = {
        no_warps = "true";
      };

      input = {
        kb_layout = "us, ua";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = "true";
        };
      };
      
      decoration = {
        rounding = 8;
        active_opacity = "1.0";
        inactive_opacity = "0.85";
        dim_inactive = true;
        dim_strength = 0.2;
        blur = {
          enabled = "true";
          size = 8;
          passes = 1;
          brightness = 1;
        };
        shadow = {
          enabled = "false";
        };
      };

      dwindle = {
        pseudotile = "true";
        preserve_split = "true";
      };
      master = {
        new_status = "master";
      };
      misc = { 
        force_default_wallpaper = -1;
        disable_hyprland_logo = "true";
      };

      workspace = [
        #"w[tv1], gapsout:0, gapsin:0, bordersize:0, rounding:0"
        "f[1], gapsout:0, gapsin:0, bordersize:0, rounding:0"
        "r[11-20], gapsout:0, gapsin:0,bordersize:0, rounding:0"
        "r[1-10], persistent:true"
      ];

      bind = [
        "$mainMod, Q, exec, set_layout.sh us && $terminal"
        "$mainMod, C, killactive,"
        "Alt_L, C, hyprtasking:killhovered,"
        "$mainMod, M, exit,"
        "$mainMod, A, exec, ani-cli --vlc --rofi -q 1080p"
        "$mainMod, Z, exec, woomer"
        "$mainMod, X, exec, hyprctl kill" 
        "$mainMod, E, exec, $fileManager"
        "$mainMod, D, exec, code"
        "$mainMod, w, exec, $browser"
        "$mainMod, V, togglefloating,"
        "$mainMod, H, exec, toggle_hyprpanel_visibility.sh unactive"
        "ALT, SPACE, exec, $menu"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, T, exec, Telegram &,"
        "$mainMod, B, exec, flatpak run life.bolls.bolls &,"
        "$mainMod, left, workspace, -1"
        "$mainMod, right, workspace, +1"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, G, togglegroup"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        "$mainMod SHIFT, left, movetoworkspace, -1"
        "$mainMod SHIFT, right, movetoworkspace, +1"

        "$mainMod SHIFT, W, exec, pkill -USR2 waybar && waybar_colors_update.sh &"
        "$mainMod SHIFT, Q, hyprtasking:toggle, all"
        "$mainMod SHIFT, P, exec, toggle_mpvpaper.sh"
        ", XF86AudioMute, exec, volume.sh mute"
        "SUPER, F, fullscreen,f"
        "$mainMod,XF86MonBrightnessDown, exec , blank_screen.sh"

        "$mainMod ALT, F4, exec ,echo 1 | sudo -S reboot -h nowstart"
        "ALT, F4, exec ,poweroff"

        "ALT, TAB, exec , hyprswitch gui --mod-key alt --key tab --close mod-key-release --show-workspaces-on-all-monitors --monitors eDP-1"
        ", Menu, exec, rofi -modi clipboard:~/nixos/hosts/default/scripts/bash/cliphist-rofi-img -config ~/.config/rofi/clip-config.rasi -show clipboard -show-icons"
        "$mainMod ALT, W, exec, wallp-rofi.sh"
        "$mainMod ALT, T, exec, update_telegram.sh"

        "$mainMod SHIFT, S, exec, wayfreeze & PID=$!; sleep .01; hyprshot -m region --clipboard-only; kill $PID"
        "$mainMod, I, exec, vigiland.sh"
        "$mainMod SHIFT, T, exec, anyrun"
        "$mainMod SHIFT, F, exec, hyprland_focus_modes.sh"
        "$mainMod SHIFT, E, exec, wl-paste | swappy -f -"
        "$mainMod SHIFT, R, exec, record_screen.sh"
        "$mainMod SHIFT, O, exec, record_screen.sh ao"
        "$mainMod SHIFT, I, exec, record_screen.sh ai"
        "$mainMod SHIFT, X, exec, record_screen_as_camera.sh"
        "$mainMod SHIFT, C, exec, phone_camera.sh"
        "$mainMod ALT, C, exec, phone_camera.sh -c"

        "Shift_L, Alt_L, exec, set_layout.sh"
        "Alt_L, Shift_L, exec, set_layout.sh"
        
        "Control_L, bracketleft, exec, echo 'multiply speed 0.9' | socat - /tmp/mpv-socket"
        "Control_L, bracketright, exec, echo 'multiply speed 1.1' | socat - /tmp/mpv-socket"

        "Alt_L, T, exec, ~/Downloads/Thorium.AppImage"
        
        "Control_L, mouse:274, global, org.chromium.Chromium:playerctl-menu"
        ",mouse:274, global, org.chromium.Chromium:example-menu"
      ];

      binde = [
        ", XF86AudioRaiseVolume, exec, volume.sh up"
        ", XF86AudioLowerVolume, exec, volume.sh down"
        ",XF86MonBrightnessDown, exec , brightness.sh down 10"
        "CapsLock,XF86MonBrightnessDown, exec , brightness.sh down 1"
        ",XF86MonBrightnessUp, exec ,brightness.sh up 10"
        "CapsLock,XF86MonBrightnessUp, exec ,brightness.sh up 1"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      binds = [
        "Super_L&Alt_L, 1, exec, switch_monitor.sh 1"
        "Super_L&Alt_L, 2, exec, switch_monitor.sh 2"
        "Super_L&Alt_L, 3, exec, switch_monitor.sh 3"
        "Super_L&Alt_L, 4, exec, switch_monitor.sh 4"
        "Super_L&Alt_L, 5, exec, switch_monitor.sh 5"
        "Super_L&Alt_L, 6, exec, switch_monitor.sh 6"
        "Super_L&Alt_L, 7, exec, switch_monitor.sh 7"
        "Super_L&Alt_L, 8, exec, switch_monitor.sh 8"
        "Super_L&Alt_L, 9, exec, switch_monitor.sh 9"

        "Super_L&Alt_R, 1, exec, switch_monitor.sh 1 view"
        "Super_L&Alt_R, 2, exec, switch_monitor.sh 2 view"
        "Super_L&Alt_R, 3, exec, switch_monitor.sh 3 view"
        "Super_L&Alt_R, 4, exec, switch_monitor.sh 4 view"
        "Super_L&Alt_R, 5, exec, switch_monitor.sh 5 view"
        "Super_L&Alt_R, 6, exec, switch_monitor.sh 6 view"
        "Super_L&Alt_R, 7, exec, switch_monitor.sh 7 view"
        "Super_L&Alt_R, 8, exec, switch_monitor.sh 8 view"
        "Super_L&Alt_R, 9, exec, switch_monitor.sh 9 view"
      ];

      windowrule = [
        "float, class:(goal-tracker)|(.goal-tracker-wrapped)|(gcolor3)|(pavucontrol)|(kando)|(zenity)|(org.gnome.SystemMonitor)|(org.gnome.clocks)|(org.pulseaudio.pavucontrol)|(gnome-power-statistics)|(.blueman-manager-wrapped)|(.scrcpy-wrapped)"
        "rounding 8, class:(gcolor3)|(pavucontrol)|(kando)|(zenity)|(org.gnome.SystemMonitor)|(org.gnome.clocks)|(org.pulseaudio.pavucontrol)|(gnome-power-statistics)|(.blueman-manager-wrapped)|(.scrcpy-wrapped)"
        "tile, class:(.scrcpy-wrapped)|(.qemu-system-x86_64-wrapped)|(qemu)"
        #"workspace empty class:(Waydroid)|(qemu)|(virt-viewer)|(.qemu-system-x86_64-wrapped)"
        "fullscreen, class:(Waydroid)|(qemu)|(.qemu-system-x86_64-wrapped)"
        "noblur, class:kando"
        "opaque, class:kando"
        "size 100% 100%, class:kando"
        "size 40% 50%, class:zenity"
        "size 50% 50%, class:(goal-tracker)|(.goal-tracker-wrapped)"
        "noborder, class:kando"
        "noanim, class:kando"
        "pin, class:kando"
      ];

      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "float, title:Authentication Required"
        "float, title:Rename \".*\""       
        "fullscreen, title:Waydroid"
        #"workspace empty title:Waydroid"
        #"workspace +0 title:Authentication Required"
        #"workspace +0 title:System Monitor"
        #"workspace +0 title:Volume"
        #"workspace +0 title:Power Statistics"
        "bordersize 3, floating:1"
        "rounding 8, floating:1"
        "noanim, onworkspace:r[11-20]"
        "noblur, onworkspace:r[11-20]"
        "noborder, onworkspace:r[11-20]"
        "nodim, onworkspace:r[11-20]"
        "opaque, onworkspace:r[11-20]"
      ];

      "plugin:overview" = {
        drawActiveWorkspace = true;
        overrideAnimSpeed = "5";
        #exitOnSwitch = "true";
        disableGestures = "true";
        showEmptyWorkspace = "true";
        overrideGaps = "true";
        gapsIn = 0;
        gapsOut = 0;
        workspaceMargin = 7;
        reservedArea = 0;
        disableBlur = true;
        workspaceActiveBackground = "$color3"; #"rgb(${builtins.replaceStrings ["#"] [""] config.pywal-nix.colourScheme.colours.colour3})";
        workspaceInactiveBackground = "$color4"; #" #rgb(${builtins.replaceStrings ["#"] [""] config.pywal-nix.colourScheme.colours.colour4})";
        workspaceActiveBorder = "$color1"; #"rgb(${builtins.replaceStrings ["#"] [""] config.pywal-nix.colourScheme.colours.colour1})";
        workspaceInactiveBorder = "$color15"; #"rgb(${builtins.replaceStrings ["#"] [""] config.pywal-nix.colourScheme.colours.colour15})";
        dragAlpha = "0.7";
        workspaceBorderSize = 2;
        panelHeight = 118;
        #autoDrag = false;
        autoScroll = true;
        #onBottom = true;
      };

      
      "plugin:split-monitor-workspaces" = {
        count = 10;
        keep_focused = 0;
        enable_notifications = 0;
        enable_persistent_workspaces = 1;
      };

      "plugin:hyprexpo" = {
        columns = 3;
        gap_size = 8;
        bg_col = "$background";
        workspace_method = "first 1";
        enable_gesture = false;
      };

      "plugin:hyprtasking" = {
        layout = "grid";
        gap_size = 5;
        bg_color = "$background";
        border_size = 2;
        
        "gestures" = {
            enabled = false;
        };

        exit_on_hovered = false;
        gaps = {
            rows = 3;
        };
        linear = {
            height = 300;
            scroll_speed = "1.1";
        };
        grid = {
          rows = 3;
        };
      };

      "plugin:touch_gestures" = {
        hyprgrass-bind = [
          ", edge:r:l, workspace, +1"
          ", edge:l:r, workspace, -1"
          ", swipe:4:d, killactive"
          ", tap:3, global, kando:example-menu"
        ];
      };

      "plugin:hyprgrass-pulse" = {
        edge = "r";
      };
      

    };

  };

}