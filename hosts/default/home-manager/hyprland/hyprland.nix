{ config, pkgs, inputs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    package = inputs.hyprland.packages.${pkgs.system}.hyprland; 

    plugins = [
      inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
      #inputs.hyprsplit.packages.${pkgs.system}.hyprsplit
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      #inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
      #inputs.hyprtasking.packages.${pkgs.system}.hyprtasking
    ];

    settings = {
      
      source = "/home/yaros/.cache/wal/colors-hyprland.conf";
      monitor = ",preferred,auto,1"; 

      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$menu" = "layout_msg.sh us && rofi -show drun -config ~/nixos/hosts/default/rofi/config.rasi";
      "$browser" = "firefox";
      "$mainMod" = "SUPER";

      exec-once = [
        "hyprlock || hyprctl dispatch exit"
        "hupridle"
        "swww-daemon"
        #"sleep 2 && waybar"
        #"dunst"
        "hyprctl setcursor volantes_cursors 24"
        "sleep 2 && swipe_up.sh && swipe_down.sh"
        "lxqt-policykit-agent"
        "systemctl --user start battery"
        "systemctl --user start battery_reset"
        "kando"
        "touchegg"
        "thunar --daemon"
        "sleep 5 && hyprpanel useTheme /home/yaros/.cache/wal/hyprbar.json"
      ];

      general = { 
        gaps_in = 3;
        gaps_out = 0;
        border_size = 3;
        "col.active_border" = "$color1 $color2 45deg"; #"rgb(${builtins.replaceStrings ["#"] [""] config.pywal-nix.colourScheme.colours.colour1}) rgb(${builtins.replaceStrings ["#"] [""] config.pywal-nix.colourScheme.colours.colour2}) 45deg";
        "col.inactive_border" = "$color15"; #"rgb(${builtins.replaceStrings ["#"] [""] config.pywal-nix.colourScheme.colours.colour15})";
        resize_on_border = "false";
        allow_tearing = "false";
        layout = "dwindle";
      };

      gestures = {
          workspace_swipe = "true";
          workspace_swipe_distance = 60;
          workspace_swipe_min_speed_to_force = 50;
          workspace_swipe_min_fingers = "true";
          workspace_swipe_cancel_ratio = "0.5";
          workspace_swipe_touch = "true";
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
          "workspaces, 1, 6, default"
          "layersIn, 1, 3, default, slide 50%"
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
        rounding = 7;
        active_opacity = "1.0";
        inactive_opacity = "0.85";
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

      ];

      bind = [
        "$mainMod, Q, exec, layout_msg.sh us && $terminal"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, w, exec, $browser"
        "$mainMod, V, togglefloating,"
        "ALT, SPACE, exec, $menu"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, T, exec, telegram-desktop &,"
        "$mainMod, B, exec, flatpak run life.bolls.bolls &,"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

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

        #"$mainMod SHIFT, W, exec, hyprctl dispatch hyprtasking:toggle all"
        #"$mainMod SHIFT, Q, hyprtasking:toggle, all"
        "$mainMod SHIFT, P, exec, toggle_mpvpaper.sh"
        ", XF86AudioMute, exec, volume.sh mute"
        "SUPER, F, fullscreen,f"
        "$mainMod,XF86MonBrightnessDown, exec , brightnessctl set 0"

        "$mainMod ALT, F4, exec ,echo 1 | sudo -S reboot -h nowstart"
        "ALT, F4, exec ,poweroff"

        "ALT, TAB, exec , alttab.sh"
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

        "Shift_L, Alt_L, exec, layout_msg.sh"
        "Alt_L, Shift_L, exec, layout_msg.sh"
        
        "Control_L, bracketleft, exec, echo 'multiply speed 0.9' | socat - /tmp/mpv-socket"
        "Control_L, bracketright, exec, echo 'multiply speed 1.1' | socat - /tmp/mpv-socket"

        "Alt_L, T, exec, ~/Downloads/Thorium.AppImage"
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
        #"Control_L, W&P, exec, toggle_mpvpaper.sh"
      ];

      windowrule = [
        "float, (pavucontrol)|(kando)|(zenity)|(org.gnome.SystemMonitor)|(org.gnome.clocks)|(org.pulseaudio.pavucontrol)|(gnome-power-statistics)|(.blueman-manager-wrapped)|(.scrcpy-wrapped)"
        "tile, (.scrcpy-wrapped)"
        "workspace empty (Waydroid)|(qemu)|(virt-viewer)"
        "fullscreen, (Waydroid)|(qemu)"
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
        "workspace +0 title:Authentication Required"
        "workspace +0 title:System Monitor"
        "workspace +0 title:Volume"
        "workspace +0 title:Power Statistics"
        #"bordersize 0, floating:0, onworkspace:w[tv1]"
        #"rounding 0, floating:0, onworkspace:w[tv1]"
        #"bordersize 0, floating:0, onworkspace:f[1]"
        #"rounding 0, floating:0, onworkspace:f[1]"
      ];

      "plugin:overview" = {
        drawActiveWorkspace = true;
        overrideAnimSpeed = "0.01";
        #exitOnSwitch = "true";
        disableGestures = "true";
        showEmptyWorkspace = "true";
        overrideGaps = "true";
        gapsIn = 0;
        gapsOut = 0;
        workspaceMargin = 7;
        reservedArea = 38;
        disableBlur = "true";
        workspaceActiveBackground = "$color3"; #"rgb(${builtins.replaceStrings ["#"] [""] config.pywal-nix.colourScheme.colours.colour3})";
        workspaceInactiveBackground = "$color4"; #" #rgb(${builtins.replaceStrings ["#"] [""] config.pywal-nix.colourScheme.colours.colour4})";
        workspaceActiveBorder = "$color1"; #"rgb(${builtins.replaceStrings ["#"] [""] config.pywal-nix.colourScheme.colours.colour1})";
        workspaceInactiveBorder = "$color15"; #"rgb(${builtins.replaceStrings ["#"] [""] config.pywal-nix.colourScheme.colours.colour15})";
        dragAlpha = "0.7";
        workspaceBorderSize = 2;
        panelHeight = 200;
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
        gap_size = 20;
        bg_color = "$background";
        border_size = 4;
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

    };

  };

}