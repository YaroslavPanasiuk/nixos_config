{ config, pkgs, inputs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    package = inputs.hyprland.packages.${pkgs.system}.hyprland; 

    plugins = [
      #inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
      #inputs.hyprsplit.packages.${pkgs.system}.hyprsplit
      #inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      #inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
      inputs.hyprtasking.packages.${pkgs.system}.hyprtasking
      inputs.hyprgrass.packages.${pkgs.system}.hyprgrass-pulse
      inputs.hyprgrass.packages.${pkgs.system}.default
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
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
      "$browser" = "firefox";
      "$mainMod" = "SUPER";

      exec-once = [
        "hyprlock"
        "hypridle"
        "swww-daemon"
        "pkill dunst"
        "hyprctl setcursor volantes_cursors 24"
        "sleep 2 && hyprctl dispatch overview:close"
        "lxqt-policykit-agent"
        "systemctl --user start battery"
        "systemctl --user start battery_reset"
        "kando"
        "touchegg"
        "thunar --daemon"
        "wl-paste --watch cliphist store"
        "hyprswitch init --size-factor 4 --custom-css ~/.config/hyprswitch/hyprswitch.css"
        "sleep 10 && hyprpanel useTheme ~/.cache/wal/hyprbar.json"
      ];

      general = { 
        gaps_in = 3;
        gaps_out = 5;
        border_size = 3;
        "col.active_border" = "$color1 $color2 45deg"; #"rgb(${builtins.replaceStrings ["#"] [""] config.pywal-nix.colourScheme.colours.colour1}) rgb(${builtins.replaceStrings ["#"] [""] config.pywal-nix.colourScheme.colours.colour2}) 45deg";
        "col.inactive_border" = "$color15"; #"rgb(${builtins.replaceStrings ["#"] [""] config.pywal-nix.colourScheme.colours.colour15})";
        resize_on_border = "false";
        allow_tearing = "false";
        layout = "dwindle";
      };

      gestures = {
          workspace_swipe = "true";
          workspace_swipe_distance = 1500;
          workspace_swipe_min_speed_to_force = 5;
          workspace_swipe_min_fingers = "true";
          workspace_swipe_cancel_ratio = "0.1";
          workspace_swipe_direction_lock = false;
          #workspace_swipe_touch = "true";
          workspace_swipe_invert = "true";
          #workspace_swipe_create_new = "false";
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
        "w[tv1], gapsout:0, gapsin:0, bordersize:0, rounding:0"
        "f[1], gapsout:0, gapsin:0, bordersize:0, rounding:0"
        "r[11-20], gapsout:0, gapsin:0,bordersize:0, rounding:0"
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
        "$mainMod, T, exec, telegram-desktop &,"
        "$mainMod, B, exec, flatpak run life.bolls.bolls &,"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod, 1, split-workspace, 1"
        "$mainMod, 2, split-workspace, 2"
        "$mainMod, 3, split-workspace, 3"
        "$mainMod, 4, split-workspace, 4"
        "$mainMod, 5, split-workspace, 5"
        "$mainMod, 6, split-workspace, 6"
        "$mainMod, 7, split-workspace, 7"
        "$mainMod, 8, split-workspace, 8"
        "$mainMod, 9, split-workspace, 9"
        "$mainMod, 0, split-workspace, 10"

        "$mainMod SHIFT, 1, split-movetoworkspace, 1"
        "$mainMod SHIFT, 2, split-movetoworkspace, 2"
        "$mainMod SHIFT, 3, split-movetoworkspace, 3"
        "$mainMod SHIFT, 4, split-movetoworkspace, 4"
        "$mainMod SHIFT, 5, split-movetoworkspace, 5"
        "$mainMod SHIFT, 6, split-movetoworkspace, 6"
        "$mainMod SHIFT, 7, split-movetoworkspace, 7"
        "$mainMod SHIFT, 8, split-movetoworkspace, 8"
        "$mainMod SHIFT, 9, split-movetoworkspace, 9"
        "$mainMod SHIFT, 0, split-movetoworkspace, 10"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        #"$mainMod SHIFT, W, exec, hyprctl dispatch hyprtasking:toggle all"
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

        "$mainMod SHIFT, S, exec, hyprshot -m region --clipboard-only"
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
        
        "Control_L, mouse:274, global, kando:playerctl-menu"
        ",mouse:274, global, kando:example-menu"
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
        "float, (pavucontrol)|(kando)|(zenity)|(org.gnome.SystemMonitor)|(org.gnome.clocks)|(org.pulseaudio.pavucontrol)|(gnome-power-statistics)|(.blueman-manager-wrapped)|(.scrcpy-wrapped)"
        "tile, (.scrcpy-wrapped)|(.qemu-system-x86_64-wrapped)|(qemu)"
        "workspace empty (Waydroid)|(qemu)|(virt-viewer)|(.qemu-system-x86_64-wrapped)"
        "fullscreen, (Waydroid)|(qemu)|(.qemu-system-x86_64-wrapped)"
        "noblur, kando"
        "opaque, kando"
        "size 100% 100%, kando"
        "size 40% 50%, zenity"
        "noborder, kando"
        "noanim, kando"
        "pin, kando"
      ];

      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "float, title:Authentication Required"
        "fullscreen, title:Waydroid"
        "workspace empty title:Waydroid"
        "workspace +0 title:Authentication Required"
        "workspace +0 title:System Monitor"
        "workspace +0 title:Volume"
        "workspace +0 title:Power Statistics"
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
        gestures = {
          enabled = 0;
          open_positive = 0;
        };
        exit_behavior = "active hovered interacted original";
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