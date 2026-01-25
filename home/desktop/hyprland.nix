{
  pkgs,
  hostName,
  lib,
  ...
}:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };

    settings = {
      "$MOD" = "SUPER";
      "$MOD_SHIFT" = "SUPER SHIFT";
      "$MOD_ALT" = "SUPER ALT";
      "$MOD_CTRL" = "SUPER CTRL";

      "$uwsm" = "uwsm app --";

      "$terminal" = "${pkgs.kitty}/bin/kitty --title terminal";
      "$fileManager" = "${pkgs.yazi}/bin/yazi";
      "$menu" = "${pkgs.rofi}/bin/rofi -show drun";
      "$browser" = "$uwsm ${pkgs.firefox}/bin/firefox";
      "$screenLock" = "${pkgs.hyprlock}/bin/hyprlock";
      "$notes" = "obsidian";
      "$colorPicker" = "hyprpicker";
      "$snap" = "snap";
      "$activateNightMode" = "hyprsunset --temperature 1000";
      "$disableNightMode" = "systemctl stop --user hyprsunset";
      "$toggleSound" = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      "$setSound100" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 100%";
      "$toggleWaybar" = "pkill -SIGUSR1 waybar";

      env = [
        "XCURSOR_THEME,Bibata-Modern-Ice"
        "XCURSOR_SIZE,20"
        "XDG_MENU_PREFIX,plasma-"
        "LD_LIBRARY_PATH,${
          pkgs.lib.makeLibraryPath [
            pkgs.vulkan-loader
            pkgs.xorg.libX11
            pkgs.xorg.libXcursor
            pkgs.xorg.libXi
            pkgs.xorg.libXrandr
            pkgs.libxkbcommon
            pkgs.wayland
            pkgs.libGL
            pkgs.alsa-lib
          ]
        }"
        "RUST_SRC_PATH,${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}"
        "PKG_CONFIG_PATH,${
          pkgs.lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
            pkgs.wayland
            pkgs.libxkbcommon
            pkgs.alsa-lib
            pkgs.libudev-zero
            pkgs.vulkan-loader
            pkgs.xorg.libX11
            pkgs.xorg.libXcursor
            pkgs.xorg.libXi
            pkgs.xorg.libXrandr
          ]
        }"
      ];

      animations = {
        enabled = "true";
        bezier = "bezi, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, bezi"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 7, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 7, default"
        ];
      };

      exec-once = [
        "theme-changer init"
        "awww-daemon --no-cache"
        "waybar"
        "hyprpaper"
        "hypridle"
        "awww img ~/.config/rice/current/wallpaper.png"
      ];

      general = {
        gaps_in = 4;
        gaps_out = 2;
        border_size = 2;
        resize_on_border = true;
        hover_icon_on_border = true;

        allow_tearing = false;

        layout = "dwindle";

        snap = {
          enabled = true;
          window_gap = 20;
          monitor_gap = 20;
          border_overlap = true;
          respect_gaps = true;
        };
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        smart_resizing = true;
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          new_optimizations = true;
          size = 3;
          passes = 2;
          vibrancy = 0.3;
          xray = true;
          noise = 0.4e-3;
          brightness = 0.9;
          contrast = 0.8;
          popups = true;
        };
      };

      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      misc = {
        vrr = 2;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        middle_click_paste = false;

        font_family = "JetBrainsMono Nerd Font";
      };

      monitor =
        if hostName == "Ghylak" then
          [
            "DP-2,1920x1080@60,0x180,1"
            "DP-3,2560x1440@60,1920x0,1.33"
            ",preferred,auto,1"
          ]
        else if hostName == "Murgo" then
          [
            "eDP-1,1920x1080@60,0x0,1"
            ",preferred,auto,1"
          ]
        else
          [ ",preferred,auto,1" ];

      workspace =
        if hostName == "Ghylak" then
          [
            "1, monitor:DP-2, default:true"
            "2, monitor:DP-3, default:true"
          ]
        else
          [

          ];

      input = {
        kb_layout = "us";
        mouse_refocus = 1;
        accel_profile = "flat";
        sensitivity = 1;
      }
      // lib.optionalAttrs (hostName == "Ghylak") {
        tablet = {
          output = "DP-2";
        };
      }
      // lib.optionalAttrs (hostName == "Murgo") {
        numlock_by_default = true;
        touchpad = {
          natural_scroll = false;
        };
      };

      bind = [
        "$MOD, Q, exec, $terminal"
        "$MOD, C, killactive,"
        "$MOD, W, exec, $terminal -e nvim"
        "$MOD, E, exec, $menu"
        "$MOD_SHIFT, U, exec, $screenLock"
        "$MOD, A, exec, $browser"
        "$MOD, R, exec, $notes"
        "$MOD, F, exec, $termFileManager"
        "$MOD_SHIFT, F, exec, $fileManager"
        "$MOD, G, exec, $colorPicker -a"

        "$MOD, S, exec, $snap select"
        "$MOD_SHIFT, S, exec, $snap screen"
        "$MOD_ALT, S, exec, $snap all"

        "$MOD_SHIFT, R, exec, $snap film"
        "$MOD_CTRL, R, exec, $snap film_selection"
        "$MOD_ALT, R, exec, $snap stop_recording"

        "$MOD, H, movefocus, l"
        "$MOD, L, movefocus, r"
        "$MOD, J, movefocus, d"
        "$MOD, K, movefocus, u"

        "$MOD_SHIFT, H, movewindow, l"
        "$MOD_SHIFT, L, movewindow, r"
        "$MOD_SHIFT, J, movewindow, d"
        "$MOD_SHIFT, K, movewindow, u"

        "$MOD, V, fullscreen,"
        "$MOD SHIFT, V, togglefloating,"

        "$MOD_CTRL, W, exec, $toggleWaybar"

        "$MOD, N, exec, $activateNightMode"
        "$MOD_SHIFT, N, exec, $disableNightMode"

        "$MOD, B, movetoworkspacesilent, special:minimized"
        "$MOD_SHIFT, B, togglespecialworkspace, minimized"

        "$MOD, M, togglespecialworkspace, magic"
        "$MOD, M, movetoworkspace, +0"
        "$MOD, M, togglespecialworkspace, magic"
        "$MOD, M, movetoworkspace, special:magic"
        "$MOD, M, togglespecialworkspace, magic"
      ]
      ++ (builtins.concatLists (
        builtins.genList (
          i:
          let
            ws = i + 1;
            key = if i == 9 then "0" else "${toString ws}";
          in
          [
            "$MOD, ${key}, workspace, ${toString ws}"
            "$MOD_SHIFT, ${key}, movetoworkspace, ${toString ws}"
          ]
        ) 10
      ));

      binde = [
        "$MOD_ALT, H, resizeactive, -20 0"
        "$MOD_ALT, L, resizeactive, 20 0"
        "$MOD_ALT, J, resizeactive, 0 20"
        "$MOD_ALT, K, resizeactive, 0 -20"

        "$MOD, I, exec, brightnessctl set 10%-"
        "$MOD, bracketleft, exec, brightnessctl set 10%+"
      ];

      bindm = [
        "$MOD, mouse:272, movewindow"
        "$MOD, mouse:273, resizewindow"
      ];

      bindl = [
        "$MOD_SHIFT, O, exec, $toggleSound"
        "$MOD_SHIFT, P, exec, $setSound100"
      ];

      bindle = [
        "$MOD, P, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+"
        "$MOD, O, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"
      ];

      windowrule = [
        "opacity 0.85 0.85, match:title .*pdf.*"
        "opacity 1.0 1.0, match:class firefox"
        "opacity 0.78 0.78, match:class Spotify"
        "opacity 0.88 0.88, match:title .*Vesktop*."
        "float on, match:title .*Picture-in-Picture*."
        "pin on, match:title .*Picture-in-Picture*."
      ];
    };

    extraConfig = ''
      	source = ~/.config/rice/current/border.conf
    '';
  };
}
