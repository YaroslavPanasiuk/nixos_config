---@module 'hl'

-- Variables
local browser = "zen-beta"
local fileManager = "thunar"
local mainMod = "ALT"
local menu = "set_layout.sh us && rofi -show drun"
local terminal = "kitty"
local home = os.getenv("HOME")
local colors = dofile(home .. "/.cache/wal/colors-hyprland.lua")
local second_mon = "desc:Audio Processing Technology  Ltd TYPEC demoset-1"

-- Environment Variables
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("AQ_DRM_DEVICES", "/dev/dri/card1:/dev/dri/card2")
hl.env("LIBVA_DRIVER_NAME", "nvidia")

-- Source Pywal configuration directly
hl.config({
    source = { "$HOME/.cache/wal/colors-hyprland.conf" }
})

-- Core Configurations
hl.config({
    animations = {
        enabled = true,
        bezier = {
            "myBezier, 0.05, 0.9, 0.1, 1.05",
            "linear, 0.0, 0.0, 1.0, 1.0"
        },
            
            -- Format: "name, on/off, speed, curve, [style]"
        animation = {
            "windows, 1, 5, myBezier",
            "windowsOut, 1, 5, default, popin 80%",
            "border, 1, 5, default",
            "borderangle, 1, 5, linear, loop",
            "fade, 1, 5, default",
            "workspaces, 1, 5, default, slidefade 20%"
        }
    },
    cursor = {
        no_hardware_cursors = true,
        no_warps = true,
    },
    decoration = {
        blur = {
            brightness = 1,
            enabled = true,
            passes = 1,
            size = 8,
        },
        shadow = {
            enabled = false,
        },
        active_opacity = 1.0,
        dim_inactive = true,
        dim_strength = 0.200000,
        inactive_opacity = 0.85,
        rounding = 8,
    },
    dwindle = {
        preserve_split = true,
        --pseudotile = true,
    },
    general = {
        allow_tearing = true,
        border_size = 2,
        gaps_in = 2,
        gaps_out = 2,
        layout = "dwindle",
        resize_on_border = false,
        col = {
            active_border = { colors = { colors.color1, colors.color2 }, angle = 45 },
            inactive_border = colors.color15,
        },
    },
    gestures = {
        workspace_swipe_cancel_ratio = 0.1,
        workspace_swipe_create_new = true,
        workspace_swipe_direction_lock = false,
        workspace_swipe_distance = 1500,
        workspace_swipe_invert = true,
        workspace_swipe_min_speed_to_force = 5,
    },
    input = {
        touchpad = {
            natural_scroll = true,
        },
        follow_mouse = 1,
        kb_layout = "us,ua",
        sensitivity = 0,
    },
    master = {
        new_status = "master",
    },
    misc = {
        disable_hyprland_logo = true,
        force_default_wallpaper = -1,
        focus_on_activate = true
    },
    
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.gesture({
    fingers = 3,
    direction = "down",
    action = "close"
})

-- Devices
hl.device({
    name = "ugreen-receiver--mouse",
    sensitivity = -0.6,
})
hl.device({
    name = "ugreen-ble-mouse",
    accel_profile = "adaptive",
    sensitivity = -0.8,
})
hl.device({
    name = "syna0001:00-06cb:7f28-touchpad",
    accel_profile = "adaptive",
    sensitivity = 0.1,
})

-- Monitors
hl.monitor({ output = "eDP-1", mode = "1920x1080@120", position = "0x0", scale = 1 }) 
hl.monitor({ output = second_mon, mode = "1920x1080@60", position = "1920x0", scale = 1 })
hl.monitor({ output = "phone_monitor_cable", mode = "720x1520@60", position = "-360x340", scale = 2 })
hl.monitor({ output = "phone_monitor_wifi", mode = "720x1600@30", position = "0x1080", scale = 2 }) 
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- Keybindings (General)
hl.bind("ALT + Q", hl.dsp.exec_cmd("set_layout.sh us && kitty"))
hl.bind("ALT + C", hl.dsp.window.close())
hl.bind("ALT + M", hl.dsp.exit())
hl.bind("ALT + A", hl.dsp.exec_cmd("ani-cli --vlc --rofi -q 1080p"))
hl.bind("ALT + Z", hl.dsp.exec_cmd("woomer"))
hl.bind("ALT + X", hl.dsp.exec_cmd("hyprctl kill"))
hl.bind("ALT + E", hl.dsp.exec_cmd("thunar"))
hl.bind("ALT + D", hl.dsp.exec_cmd("code"))
hl.bind("ALT + w", hl.dsp.exec_cmd("zen-beta"))
hl.bind("ALT + V", hl.dsp.window.float())
hl.bind("ALT + H", hl.dsp.exec_cmd("toggle_hyprpanel_visibility.sh unactive"))
hl.bind("ALT + SPACE", hl.dsp.exec_cmd("set_layout.sh us && rofi -show drun"))
hl.bind("ALT + P", hl.dsp.window.pseudo())
--hl.bind("ALT + J", hl.dsp.layout(nil))
hl.bind("ALT + T", hl.dsp.exec_cmd("Telegram &"))
hl.bind("ALT + B", hl.dsp.exec_cmd("flatpak run life.bolls.bolls &"))

hl.bind("ALT + G", hl.dsp.group.toggle())

hl.bind("ALT + SHIFT + W", hl.dsp.exec_cmd("pkill waybar; waybar &"))
hl.bind("ALT + SHIFT + P", hl.dsp.exec_cmd("toggle_mpvpaper.sh"))
hl.bind("ALT + F", hl.dsp.window.fullscreen())
hl.bind("ALT + F4", hl.dsp.exec_cmd("poweroff"))
hl.bind("ALT + TAB", hl.dsp.exec_cmd("hyprswitch gui --mod-key alt --key tab --close mod-key-release --show-workspaces-on-all-monitors --monitors eDP-1"))
hl.bind("CONTROL + slash", hl.dsp.exec_cmd("rofi -modi clipboard:~/nixos/hosts/default/scripts/bash/cliphist-rofi-img -config ~/.config/rofi/clip-config.rasi -show clipboard -show-icons"))

-- Complex bash bind
hl.bind("ALT + SHIFT + Q", hl.dsp.exec_cmd("firefox"))

hl.bind("ALT + I", hl.dsp.exec_cmd("vigiland.sh"))
hl.bind("ALT + SHIFT + T", hl.dsp.exec_cmd("anyrun"))
hl.bind("ALT + SHIFT + F", hl.dsp.exec_cmd("hyprland_focus_modes.sh"))
hl.bind("ALT + SHIFT + E", hl.dsp.exec_cmd("wl-paste | swappy -f -"))
hl.bind("ALT + SHIFT + R", hl.dsp.exec_cmd("record_screen.sh"))
hl.bind("ALT + SHIFT + O", hl.dsp.exec_cmd("record_screen.sh ao"))
hl.bind("ALT + SHIFT + I", hl.dsp.exec_cmd("record_screen.sh ai"))

hl.bind("SHIFT + Alt_L", hl.dsp.exec_cmd("set_layout.sh"))
hl.bind("ALT + Shift_L", hl.dsp.exec_cmd("set_layout.sh"))
hl.bind("CONTROL + bracketleft", hl.dsp.exec_cmd("echo 'multiply speed 0.9' | socat - /tmp/mpv-socket"))
hl.bind("CONTROL + bracketright", hl.dsp.exec_cmd("echo 'multiply speed 1.1' | socat - /tmp/mpv-socket"))
--hl.bind("CONTROL + F", hl.dsp.cursor.move({960, 540}))
hl.bind("mouse:274", hl.dsp.global("menu.kando.Kando:example-menu"))

-- BindE (Repeating Volume/Brightness bindings)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --monitor eDP-1 --output-volume mute-toggle"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --monitor eDP-1 --output-volume +5 --max-volume 120"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --monitor eDP-1 --output-volume -5 --max-volume 120"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --monitor eDP-1 --brightness -10"))
hl.bind("ALT + XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --monitor eDP-1 --brightness 0"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --monitor eDP-1 --brightness +10"))
hl.bind("SHIFT + XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --monitor eDP-1 --brightness -1"))
hl.bind("SHIFT + XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --monitor eDP-1 --brightness +1"))

-- Mouse Bindings
hl.bind("ALT + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("ALT + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("CONTROL + mouse:275", hl.dsp.window.drag(), { mouse = true })
hl.bind("CONTROL + mouse:276", hl.dsp.window.resize(), { mouse = true })


hl.window_rule({ name = "suppressevent_maximi", match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ name = "auth_req_float", match = { title = "Authentication Required" }, float = true })
hl.window_rule({ name = "rename_float", match = { title = "Rename .*" }, float = true })
hl.window_rule({ name = "waydroid_full", match = { title = "Waydroid" }, fullscreen = true })
hl.window_rule({ match = { title = "NixOS GTK Command Grid" }, fullscreen = true })

hl.window_rule({ 
    match = { class = "(org.gnome.PowerStats)|(goal-tracker)|(.goal-tracker-wrapped)|(gcolor3)|(pavucontrol)|(kando)|(zenity)|(org.gnome.SystemMonitor)|(org.gnome.clocks)|(org.pulseaudio.pavucontrol)|(gnome-power-statistics)|(.blueman-manager-wrapped)|(.scrcpy-wrapped)" }, 
    float = true, 
    size = "800 600", 
    center = true,
    rounding = 8,
    border_size = 2,
})

hl.window_rule({
  name = "kando",
  match = {
      class = "menu.kando.Kando",
      title = "Kando Menu"
  },
  no_blur = true,
  opaque = true,
  move = {0, 0},
  rounding = 0,
  size = { "100%", "100%" },
  border_size = 0,
  no_anim = true,
  float = true,
  pin = true,
  no_initial_focus = false
})

-- Workspace Rules
for i = 1, 9 do
  hl.workspace_rule({
    workspace = tostring(i),
    monitor = "eDP-1",
    persistent = true
  })
  hl.bind("ALT + " .. tostring(i), hl.dsp.focus({ workspace = i }))
  hl.bind("ALT + SHIFT + " .. tostring(i), hl.dsp.window.move({ workspace = i }))
end

-- Absolute Workspaces (Numpad 10-18)
local numpad_map = {
    End = 10, Down = 11, Next = 12, Left = 13, Begin = 14, 
    Right = 15, Home = 16, Up = 17, Prior = 18
}
for key, ws in pairs(numpad_map) do
    hl.workspace_rule({
        workspace = tostring(ws),
        monitor = second_mon,
        persistent = true
    })
    hl.bind("ALT + KP_" .. key, hl.dsp.focus({ workspace = ws }))
    hl.bind("ALT + SHIFT + KP_" .. key, hl.dsp.window.move({ workspace = ws }, { follow = false }))
end

hl.bind("ALT + left", hl.dsp.focus({workspace = "r-1"}))
hl.bind("ALT + right", hl.dsp.focus({workspace = "r+1"}))
hl.bind("ALT + SHIFT + left", hl.dsp.window.move({workspace = "r-1"}))
hl.bind("ALT + SHIFT + right", hl.dsp.window.move({workspace = "r+1"}))
hl.bind("ALT + mouse_up", hl.dsp.focus({workspace = "r+1"}))
hl.bind("ALT + mouse_down", hl.dsp.focus({workspace = "r-1"}))
hl.bind("ALT + CONTROL + left", hl.dsp.window.move({ monitor = "eDP-1" }))
hl.bind("ALT + CONTROL + right", hl.dsp.window.move({ monitor = second_mon }))






-- Autostart
hl.on("hyprland.start", function()    
    hl.exec_cmd("hyprctl setcursor volantes_cursors 24")
    hl.exec_cmd("hyprlock")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("ydotoold")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("systemctl --user start swayosd")
    hl.exec_cmd("lxqt-policykit-agent")
    hl.exec_cmd("systemctl --user start battery")
    hl.exec_cmd("systemctl --user start battery_reset")
    hl.exec_cmd("kando")
    hl.exec_cmd("sleep 1 && waybar")
    hl.exec_cmd("sleep 2 && hyprland_focus_modes.sh update")
    hl.exec_cmd("sleep 3 && nm-applet")
    hl.exec_cmd("sleep 5 && blueman-tray")
    hl.exec_cmd("sleep 5 && blueman-applet")
    hl.exec_cmd("thunar --daemon")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("hyprswitch init --size-factor 4 --custom-css ~/.config/hyprswitch/hyprswitch.css")
end)