{ config, pkgs, inputs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; 
    systemd.enable = true; 
    systemd.variables = ["--all"];

    plugins = [
      inputs.hyprtasking.packages.${pkgs.stdenv.hostPlatform.system}.hyprtasking
      #inputs.hyprgrass.packages.${pkgs.stdenv.hostPlatform.system}.hyprgrass-pulse
      #inputs.hyprgrass.packages.${pkgs.stdenv.hostPlatform.system}.default
      #inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
      inputs.hyprsplit.packages.${pkgs.stdenv.hostPlatform.system}.hyprsplit
      #inputs.hycov.packages.${pkgs.stdenv.hostPlatform.system}.hycov
    ];

    settings = {
      
      source = "$HOME/.cache/wal/colors-hyprland.conf";
      monitor = [
        "eDP-1,1920x1080@120,0x0,1"
        "DP-1,1920x1080@60,1920x0,1"
        "HDMI-A-1,1920x1080@60,1920x0,1"
        "phone_monitor_cable,720x1520@60,-360x340,2"
        "phone_monitor_wifi,720x1600@30,0x1080,2"
      ];
      

      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$menu" = "set_layout.sh us && rofi -show drun";
      "$browser" = "zen-beta";
      "$mainMod" = "Alt_L";

      env = [
        "AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card2"
        "LIBVA_DRIVER_NAME,nvidia"
      ];

      exec-once = [
        "hyprlock"
        "hypridle"
        "ydotoold"
        "swww-daemon"
        "systemctl --user start swayosd"
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
        allow_tearing = "true";
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

      cursor = {
        no_warps = "true";
        no_hardware_cursors = true;
      };

      input = {
        kb_layout = "us, ua";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = "true";
        };
      };

      device = [
        {
          name = "ugreen-receiver--mouse";
          #accel_profile = "flat";
          sensitivity = "-0.6";
        }
        {
          name = "ugreen-ble-mouse";
          #accel_profile = "flat";
          sensitivity = "-0.8";
        }
        {
          name = "syna0001:00-06cb:7f28-touchpad";
        accel_profile = "adaptive";
          sensitivity = "0.1";
        }
      ];

      
      
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
        "1, monitor:eDP-1, default:true"
        "r[2-9], monitor:eDP-1"
        "10, monitor:DP-1, default:true"
        "r[11-18], monitor:DP-1"
        "10, monitor:HDMI-A-1, default:true"
        "r[11-18], monitor:HDMI-A-1"
        "f[1], gapsout:0, gapsin:0, bordersize:0, rounding:0"
        "m[DP-1], gapsout:0, gapsin:0,bordersize:0, rounding:0"
        "m[HDMI-A-1], gapsout:0, gapsin:0,bordersize:0, rounding:0"
        "m[phone_monitor_cable], gapsout:0, gapsin:0,bordersize:0, rounding:0"
        "m[phone_monitor_wifi], gapsout:0, gapsin:0,bordersize:0, rounding:0"
        "r[1-9], persistent:true"
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
        "$mainMod, left, split:workspace, -1"
        "$mainMod, right, split:workspace, +1"
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

        "$mainMod, KP_End, workspace, 10"
        "$mainMod, KP_Down, workspace, 11"
        "$mainMod, KP_Next, workspace, 12"
        "$mainMod, KP_Left, workspace, 13"
        "$mainMod, KP_Begin, workspace, 14"
        "$mainMod, KP_Right, workspace, 15"
        "$mainMod, KP_Home, workspace, 16"
        "$mainMod, KP_Up, workspace, 17"
        "$mainMod, KP_Prior, workspace, 18"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"

        "$mainMod SHIFT, KP_End, movetoworkspacesilent, 10"
        "$mainMod SHIFT, KP_Down, movetoworkspacesilent, 11"
        "$mainMod SHIFT, KP_Next, movetoworkspacesilent, 12"
        "$mainMod SHIFT, KP_Left, movetoworkspacesilent, 13"
        "$mainMod SHIFT, KP_Begin, movetoworkspacesilent, 14"
        "$mainMod SHIFT, KP_Right, movetoworkspacesilent, 15"
        "$mainMod SHIFT, KP_Home, movetoworkspacesilent, 16"
        "$mainMod SHIFT, KP_Up, movetoworkspacesilent, 17"
        "$mainMod SHIFT, KP_Prior, movetoworkspacesilent, 18"

        "$mainMod, mouse_down, split:workspace, e+1"
        "$mainMod, mouse_up, split:workspace, e-1"

        "$mainMod SHIFT, left, split:movetoworkspace, -1"
        "$mainMod SHIFT, right, split:movetoworkspace, +1"

        "$mainMod Control_L, left, movewindow, mon:l"
        "$mainMod Control_L, right, movewindow, mon:r"

        "$mainMod SHIFT, W, exec, pkill waybar; waybar &"
        "$mainMod SHIFT, Q, hyprtasking:toggle, all"
        "$mainMod SHIFT, P, exec, toggle_mpvpaper.sh"
        ", XF86AudioMute, exec, swayosd-client --monitor eDP-1 --output-volume mute-toggle"
        "$mainMod, F, fullscreen,f"
        "$mainMod,XF86MonBrightnessDown, exec , blank_screen.sh"

        "ALT, F4, exec ,poweroff"

        "ALT, TAB, exec , hyprswitch gui --mod-key alt --key tab --close mod-key-release --show-workspaces-on-all-monitors --monitors eDP-1"
        "Control_L, slash, exec, rofi -modi clipboard:~/nixos/hosts/default/scripts/bash/cliphist-rofi-img -config ~/.config/rofi/clip-config.rasi -show clipboard -show-icons"

        "$mainMod SHIFT, S, exec, wayfreeze & PID=$!; sleep .01; hyprshot -m region --clipboard-only; kill $PID"
        "$mainMod, I, exec, vigiland.sh"
        "$mainMod SHIFT, T, exec, anyrun"
        "$mainMod SHIFT, F, exec, hyprland_focus_modes.sh"
        "$mainMod SHIFT, E, exec, wl-paste | swappy -f -"
        "$mainMod SHIFT, R, exec, record_screen.sh"
        "$mainMod SHIFT, O, exec, record_screen.sh ao"
        "$mainMod SHIFT, I, exec, record_screen.sh ai"

        "Shift_L, Alt_L, exec, set_layout.sh"
        "Alt_L, Shift_L, exec, set_layout.sh"
        
        "Control_L, bracketleft, exec, echo 'multiply speed 0.9' | socat - /tmp/mpv-socket"
        "Control_L, bracketright, exec, echo 'multiply speed 1.1' | socat - /tmp/mpv-socket"
        
        "Control_L, mouse:274, movecursor, 960 540"
        ",mouse:274, global, org.chromium.Chromium:example-menu"
        ",CapsLock, exec, swayosd-client --monitor eDP-1 --caps-lock"
      ];

      binde = [
        ", XF86AudioRaiseVolume, exec, swayosd-client --monitor eDP-1 --output-volume raise --max-volume 120"
        ", XF86AudioLowerVolume, exec, swayosd-client --monitor eDP-1 --output-volume lower --max-volume 120"
        ",XF86MonBrightnessDown, exec , swayosd-client --monitor eDP-1 --brightness -10"
        ",XF86MonBrightnessUp, exec , swayosd-client --monitor eDP-1 --brightness +10"
        "Control_L,XF86MonBrightnessUp, exec ,ddcutil --model TYPEC setvcp 10 + 10; ddcutil --model HDMI setvcp 10 + 10"
        "Control_L,XF86MonBrightnessDown, exec ,ddcutil --model TYPEC setvcp 10 - 10; ddcutil --model HDMI setvcp 10 + 10"
        "Control_L Alt_L,XF86MonBrightnessUp, exec ,adb shell settings put system screen_brightness_mode 0; adb shell settings put system screen_brightness $(($(adb shell settings get system screen_brightness)+10))"
        "Control_L Alt_L,XF86MonBrightnessDown, exec ,adb shell settings put system screen_brightness_mode 0; adb shell settings put system screen_brightness $(($(adb shell settings get system screen_brightness)-10))"
        "Shift_L,XF86MonBrightnessDown, exec , swayosd-client --monitor eDP-1 --brightness -1"
        "Shift_L,XF86MonBrightnessUp, exec , swayosd-client --monitor eDP-1 --brightness +1"
      ];

      bindm = [
        "$mainMod, mouse:275, movewindow"
        "$mainMod, mouse:276, resizewindow"
        "$mainMod Control_L, mouse:272, movewindow"
        "$mainMod Control_L, mouse:273, resizewindow"
      ];

      windowrule = [
        "float, class:(xdg-desktop-portal-gtk)|(speedread-float)|(goal-tracker)|(.goal-tracker-wrapped)|(gcolor3)|(pavucontrol)|(kando)|(zenity)|(org.gnome.SystemMonitor)|(org.gnome.clocks)|(org.pulseaudio.pavucontrol)|(gnome-power-statistics)|(.blueman-manager-wrapped)|(.scrcpy-wrapped)"
        "rounding 8, class:(gcolor3)|(pavucontrol)|(kando)|(zenity)|(org.gnome.SystemMonitor)|(org.gnome.clocks)|(org.pulseaudio.pavucontrol)|(gnome-power-statistics)|(.blueman-manager-wrapped)|(.scrcpy-wrapped)"
        "tile, class:(.scrcpy-wrapped)|(.qemu-system-x86_64-wrapped)|(qemu)"
        #"workspace empty class:(Waydroid)|(qemu)|(virt-viewer)|(.qemu-system-x86_64-wrapped)"
        "fullscreen, class:(Waydroid)|(qemu)|(.qemu-system-x86_64-wrapped)"
        "noblur, class:kando"
        "opaque, class:kando"
        "size 100% 100%, class:kando"
        "size 60% 60%, class:xdg-desktop-portal-gtk"
        "size 900 260, class:speedread-float"
        "center, class:speedread-float"
        "size 40% 50%, class:(zenity)|(pavucontrol)|(org.pulseaudio.pavucontrol)|(.blueman-manager-wrapped)"
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

      
      "plugin:hyprsplit" = {
        num_workspaces = 9;
        persistent_workspaces = true;
      };

      
      "plugin:split-monitor-workspaces" = {
        count = 9;
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