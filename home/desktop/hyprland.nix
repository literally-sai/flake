{
  pkgs,
  lib,
  config,
  palette,
  hostName,
  ...
}:

let
  host = lib.toLower hostName;
  isDesktop = host == "ghylak";
  isLaptop = host == "murgo";

  riceDir = "${config.home.homeDirectory}/.config/rice/current";

  terminal = "${pkgs.kitty}/bin/kitty";
  editor = "${pkgs.kitty}/bin/kitty --title editor -e nvim";
  browser = "${pkgs.firefox}/bin/firefox";
  launcher = "${pkgs.rofi}/bin/rofi -show drun";
  locker = "${pkgs.hyprlock}/bin/hyprlock";
  clipboard = "${pkgs.cliphist}/bin/cliphist list | ${pkgs.rofi}/bin/rofi -dmenu -i -p clip | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy";

  monitors =
    if isDesktop then
      ''
        hl.monitor({ output = "DP-3", mode = "2560x1440@60", position = "0x0", scale = 1.333333 })
        hl.monitor({ output = "DP-2", mode = "1920x1080@60", position = "1920x0", scale = 1 })
      ''
    else if isLaptop then
      ''
        hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = 1 })
      ''
    else
      ''
        hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
      '';

  workspaces =
    if isDesktop then
      ''
        for i = 1, 5 do
          hl.workspace_rule({ workspace = tostring(i), monitor = "DP-3", default = i == 1, persistent = i <= 2 })
        end

        for i = 6, 10 do
          hl.workspace_rule({ workspace = tostring(i), monitor = "DP-2", default = i == 6, persistent = i == 6 })
        end
      ''
    else
      ''
        for i = 1, 4 do
          hl.workspace_rule({ workspace = tostring(i), persistent = i == 1 })
        end
      '';

  tablet = lib.optionalString isDesktop ''
    hl.config({
      input = {
        tablet = {
          output = "DP-3",
        },
      },
    })
  '';

  touchpad = lib.optionalString isLaptop ''
    hl.config({
      input = {
        touchpad = {
          natural_scroll = false,
          disable_while_typing = true,
          tap_to_click = true,
          drag_lock = 1,
          scroll_factor = 0.4,
        },
      },
    })

    hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
    hl.gesture({ fingers = 4, direction = "up", action = "special", workspace_name = "magic" })
  '';
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    configType = "lua";
    systemd.enable = false;
    xwayland.enable = true;

    extraLuaFiles = {
      "00-env" = ''
        hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
        hl.env("XCURSOR_SIZE", "20")
        hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
        hl.env("HYPRCURSOR_SIZE", "20")
        hl.env("NIXOS_OZONE_WL", "1")
        hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
        hl.env("MOZ_ENABLE_WAYLAND", "1")
        hl.env("SDL_VIDEODRIVER", "wayland")
        hl.env("QT_QPA_PLATFORM", "wayland;xcb")
        hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
        hl.env("GDK_BACKEND", "wayland,x11")
      '';

      "10-monitors" = ''
        ${monitors}
        ${workspaces}
      '';

      "20-look" = ''
        local ok, theme = pcall(dofile, "${riceDir}/hypr.lua")

        if not ok or type(theme) ~= "table" then
          theme = {
            accent = "rgba(${palette.hex palette.accent}ff)",
            accent2 = "rgba(${palette.hex palette.accent2}ff)",
            inactive = "rgba(${palette.hex palette.overlay}cc)",
            text = "rgba(${palette.hex palette.text}ff)",
            groupInactive = "rgba(${palette.hex palette.surface}ff)",
            background = 0xff${palette.hex palette.base},
            shadow = 0x66000000,
          }
        end

        hl.config({
          general = {
            gaps_in = ${toString palette.gaps.inner},
            gaps_out = ${toString palette.gaps.outer},
            border_size = 2,
            col = {
              active_border = {
                colors = { theme.accent, theme.accent2 },
                angle = 45,
              },
              inactive_border = theme.inactive,
            },
            resize_on_border = true,
            extend_border_grab_area = 12,
            hover_icon_on_border = true,
            allow_tearing = false,
            layout = "dwindle",
          },

          decoration = {
            rounding = ${toString palette.radius},
            rounding_power = 2.4,
            active_opacity = 1.0,
            inactive_opacity = 0.94,
            fullscreen_opacity = 1.0,
            dim_inactive = true,
            dim_strength = 0.1,
            blur = {
              enabled = true,
              size = 6,
              passes = 3,
              new_optimizations = true,
              xray = true,
              ignore_opacity = true,
              noise = 0.015,
              contrast = 1.1,
              brightness = 0.85,
              vibrancy = 0.2,
              popups = true,
              popups_ignorealpha = 0.4,
            },
            shadow = {
              enabled = true,
              range = 22,
              render_power = 3,
              color = theme.shadow,
            },
          },

          animations = {
            enabled = true,
          },

          dwindle = {
            preserve_split = true,
            smart_resizing = true,
            force_split = 2,
          },

          master = {
            new_status = "master",
          },

          group = {
            groupbar = {
              enabled = true,
              height = 16,
              indicator_height = 2,
              font_family = "${palette.font.sans}",
              font_size = 10,
              gradients = false,
              rounding = 6,
              text_color = theme.text,
              col = {
                active = theme.accent,
                inactive = theme.groupInactive,
              },
            },
          },

          binds = {
            workspace_back_and_forth = true,
            allow_workspace_cycles = true,
            movefocus_cycles_fullscreen = false,
          },

          misc = {
            disable_hyprland_logo = true,
            disable_splash_rendering = true,
            force_default_wallpaper = 0,
            focus_on_activate = true,
            animate_manual_resizes = true,
            animate_mouse_windowdragging = true,
            enable_swallow = true,
            swallow_regex = "^(kitty|com.mitchellh.ghostty)$",
            middle_click_paste = false,
            background_color = theme.background,
          },

          cursor = {
            inactive_timeout = 5,
            no_hardware_cursors = 2,
          },

          input = {
            kb_layout = "us",
            follow_mouse = 1,
            accel_profile = "flat",
            sensitivity = 1,
            numlock_by_default = true,
            repeat_rate = 40,
            repeat_delay = 300,
          },

          xwayland = {
            force_zero_scaling = true,
          },
        })

        ${tablet}
        ${touchpad}

        hl.curve("snap", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1 } } })
        hl.curve("glide", { type = "bezier", points = { { 0.25, 1 }, { 0.3, 1 } } })
        hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
        hl.curve("bounce", { type = "spring", mass = 1, stiffness = 220, dampening = 22 })

        hl.animation({ leaf = "global", enabled = true, speed = 7, bezier = "glide" })
        hl.animation({ leaf = "border", enabled = true, speed = 6, bezier = "linear" })
        hl.animation({ leaf = "windows", enabled = true, speed = 5, spring = "bounce" })
        hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.5, spring = "bounce", style = "popin 88%" })
        hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "snap", style = "popin 92%" })
        hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "snap" })
        hl.animation({ leaf = "layers", enabled = true, speed = 4, bezier = "glide" })
        hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "glide", style = "fade" })
        hl.animation({ leaf = "layersOut", enabled = true, speed = 3, bezier = "linear", style = "fade" })
        hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "glide", style = "slidefade 18%" })
        hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "glide", style = "slidevert" })
      '';

      "30-rules" = ''
        hl.window_rule({
          name = "suppress-maximize",
          match = { class = ".*" },
          suppress_event = "maximize",
        })

        hl.window_rule({
          name = "fix-xwayland-drags",
          match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
          no_focus = true,
        })

        hl.window_rule({ match = { class = "^(firefox)$" }, opacity = "1.0 1.0" })
        hl.window_rule({ match = { class = "^(Spotify|spotify)$" }, opacity = "0.9 0.78" })
        hl.window_rule({ match = { class = "^(vesktop|discord|WebCord)$" }, opacity = "0.95 0.88" })
        hl.window_rule({ match = { class = "^(steam|steam_app.*|gamescope)$" }, opaque = true, no_blur = true })

        hl.window_rule({
          name = "pip",
          match = { title = ".*Picture-in-Picture.*" },
          float = true,
          pin = true,
          size = "480 270",
          move = "monitor_w-500 monitor_h-300",
        })

        hl.window_rule({
          name = "float-dialogs",
          match = { class = "^(pavucontrol|blueman-manager|nm-connection-editor|xdg-desktop-portal-gtk)$" },
          float = true,
          center = true,
          size = "820 560",
        })

        hl.window_rule({
          name = "float-pickers",
          match = { title = "^(Open File|Save File|Open Folder|Choose Files|File Upload)(.*)$" },
          float = true,
          center = true,
          size = "900 620",
        })

        hl.window_rule({ match = { class = "^(imv|mpv|vlc)$" }, float = true, center = true })
        hl.window_rule({ match = { workspace = "special:magic" } })

        hl.layer_rule({ match = { namespace = "^waybar$" }, blur = true, ignore_alpha = 0.35 })
        hl.layer_rule({ match = { namespace = "^rofi$" }, blur = true, ignore_alpha = 0.25 })
        hl.layer_rule({ match = { namespace = "^notifications$" }, blur = true, ignore_alpha = 0.35 })
        hl.layer_rule({ match = { namespace = "^(hyprpicker|selection)$" }, no_anim = true })
      '';

      "40-binds" = ''
        local mod = "SUPER"

        hl.bind(mod .. " + Q", hl.dsp.exec_cmd("${terminal}"))
        hl.bind(mod .. " + W", hl.dsp.exec_cmd("${editor}"))
        hl.bind(mod .. " + E", hl.dsp.exec_cmd("${launcher}"))
        hl.bind(mod .. " + F", hl.dsp.exec_cmd("${browser}"))
        hl.bind(mod .. " + C", hl.dsp.window.close())
        hl.bind(mod .. " + SHIFT + C", hl.dsp.window.kill())

        hl.bind(mod .. " + S", hl.dsp.exec_cmd("snap select"))
        hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("snap screen"))
        hl.bind(mod .. " + ALT + S", hl.dsp.exec_cmd("snap all"))
        hl.bind(mod .. " + ALT + V", hl.dsp.exec_cmd("${clipboard}"))
        hl.bind(mod .. " + ALT + X", hl.dsp.exec_cmd("${pkgs.hyprpicker}/bin/hyprpicker -a"))

        hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
        hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
        hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
        hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))

        hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
        hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
        hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
        hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))

        hl.bind(mod .. " + ALT + H", hl.dsp.window.resize({ x = -40, y = 0 }), { repeating = true })
        hl.bind(mod .. " + ALT + L", hl.dsp.window.resize({ x = 40, y = 0 }), { repeating = true })
        hl.bind(mod .. " + ALT + J", hl.dsp.window.resize({ x = 0, y = 40 }), { repeating = true })
        hl.bind(mod .. " + ALT + K", hl.dsp.window.resize({ x = 0, y = -40 }), { repeating = true })

        hl.bind(mod .. " + V", hl.dsp.window.fullscreen({ action = "toggle" }))
        hl.bind(mod .. " + SHIFT + V", hl.dsp.window.float({ action = "toggle" }))
        hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
        hl.bind(mod .. " + Space", hl.dsp.layout("togglesplit"))
        hl.bind(mod .. " + T", hl.dsp.group.toggle())
        hl.bind(mod .. " + Tab", hl.dsp.window.cycle_next({ next = true }))
        hl.bind(mod .. " + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }))
        hl.bind(mod .. " + CTRL + Space", hl.dsp.window.pin({ action = "toggle" }))

        hl.bind(mod .. " + B", hl.dsp.window.move({ workspace = "special:magic" }))
        hl.bind(mod .. " + SHIFT + B", hl.dsp.workspace.toggle_special("magic"))
        hl.bind(mod .. " + M", hl.dsp.workspace.toggle_special("magic"))

        hl.bind(mod .. " + CTRL + W", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))
        hl.bind(mod .. " + CTRL + P", hl.dsp.exec_cmd("${locker}"))
        hl.bind(mod .. " + CTRL + T", hl.dsp.exec_cmd("theme-changer next"))
        hl.bind(mod .. " + CTRL + R", hl.dsp.exec_cmd("hyprctl reload"))
        hl.bind(mod .. " + SHIFT + Q", hl.dsp.exit())

        for i = 1, 9 do
          hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
          hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, follow = false }))
        end

        -- Workspace 10 mapped to key 0
        hl.bind(mod .. " + 0", hl.dsp.focus({ workspace = 10 }))
        hl.bind(mod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10, follow = false }))

        hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
        hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
        hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
        hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

        hl.bind(mod .. " + comma", hl.dsp.focus({ monitor = "-" }))
        hl.bind(mod .. " + period", hl.dsp.focus({ monitor = "+" }))
        hl.bind(mod .. " + SHIFT + comma", hl.dsp.window.move({ monitor = "-", follow = true }))
        hl.bind(mod .. " + SHIFT + period", hl.dsp.window.move({ monitor = "+", follow = true }))

        hl.bind(mod .. " + P", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%+"), { repeating = true })
        hl.bind(mod .. " + O", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"), { repeating = true })
        hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 100%"))
        hl.bind(mod .. " + SHIFT + O", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
        hl.bind(mod .. " + I", hl.dsp.exec_cmd("brightnessctl set 10%-"), { repeating = true })
        hl.bind(mod .. " + bracketleft", hl.dsp.exec_cmd("brightnessctl set 10%+"), { repeating = true })

        hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
        hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
        hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
        hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
        hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
        hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
        hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
        hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

        hl.define_submap("resize", function()
          hl.bind("H", hl.dsp.window.resize({ x = -40, y = 0 }), { repeating = true })
          hl.bind("L", hl.dsp.window.resize({ x = 40, y = 0 }), { repeating = true })
          hl.bind("J", hl.dsp.window.resize({ x = 0, y = 40 }), { repeating = true })
          hl.bind("K", hl.dsp.window.resize({ x = 0, y = -40 }), { repeating = true })
          hl.bind("Escape", hl.dsp.submap("default"))
          hl.bind("Return", hl.dsp.submap("default"))
        end)

        hl.bind(mod .. " + R", hl.dsp.submap("resize"))
      '';

      "50-autostart" = ''
        hl.on("hyprland.start", function()
          hl.exec_cmd("awww-daemon")
          hl.exec_cmd("setsid waybar")
          hl.exec_cmd("${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store")
          hl.exec_cmd("${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store")
        end)
      '';
    };
  };
}
