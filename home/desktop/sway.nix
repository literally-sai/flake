{
  pkgs,
  hostName,
  lib,
  ...
}:

{
  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;

    extraSessionCommands = ''
      export XCURSOR_THEME=Bibata-Modern-Ice
      export XCURSOR_SIZE=20
    '';

    config =
      let
        modifier = "Mod4";
      in
      {
        inherit modifier;

        terminal = "${pkgs.kitty}/bin/kitty --title terminal";
        menu = "${pkgs.rofi}/bin/rofi -show drun";

        startup = [
          { command = "pkill awww-daemon"; }
          { command = "exec awww-daemon"; }
          { command = "exec theme-changer init"; }
          { command = "waybar"; }
        ];

        gaps = {
          inner = 4;
          outer = 2;
        };

        window = {
          border = 2;
          titlebar = false;
          commands = [
            {
              criteria = {
                title = ".*pdf.*";
              };
              command = "opacity 0.85";
            }
            {
              criteria = {
                class = "firefox";
              };
              command = "opacity 1.0";
            }
            {
              criteria = {
                class = "Spotify";
              };
              command = "opacity 0.78";
            }
            {
              criteria = {
                title = ".*Vesktop.*";
              };
              command = "opacity 0.88";
            }
            {
              criteria = {
                title = ".*Picture-in-Picture.*";
              };
              command = "floating enable, sticky enable";
            }
          ];
        };

        input = {
          "*" = {
            xkb_layout = "us";
            accel_profile = "flat";
            pointer_accel = "1";
          };
        }
        // lib.optionalAttrs (hostName == "Ghylak") {
          "type:tablet_tool" = {
            map_to_output = "DP-2";
          };
        }
        // lib.optionalAttrs (hostName == "Murgo") {
          "type:touchpad" = {
            natural_scroll = "disabled";
          };
        };

        output =
          if hostName == "Ghylak" then
            {
              "HDMI-A-1" = {
                mode = "1920x1080@60Hz";
                pos = "0 180";
                scale = "1";
              };
              "DP-3" = {
                mode = "2560x1440@60Hz";
                pos = "1920 0";
                scale = "1.33";
              };
            }
          else if hostName == "Murgo" then
            {
              "eDP-1" = {
                mode = "1920x1080@60Hz";
                pos = "0 0";
                scale = "1";
              };
            }
          else
            {
              "*" = {
                bg = "#000000 solid_color";
              };
            };

        workspaceOutputAssign =
          if hostName == "Ghylak" then
            [
              {
                workspace = "1";
                output = "DP-2";
              }
              {
                workspace = "2";
                output = "DP-3";
              }
            ]
          else
            [ ];

        keybindings =
          let
            mod = modifier;
            fileManager = "${pkgs.yazi}/bin/yazi";
            browser = "${pkgs.firefox}/bin/firefox";
            screenLock = "${pkgs.hyprlock}/bin/hyprlock";
            notes = "obsidian";
            snap = "snap";
            toggleSound = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            setSound100 = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 100%";
            toggleWaybar = "pkill -SIGUSR1 waybar";
          in
          lib.mkOptionDefault {
            "${mod}+q" = "exec kitty";
            "${mod}+c" = "kill";
            "${mod}+w" = "exec kitty -e nvim";
            "${mod}+e" = "exec rofi -show drun";
            "${mod}+f" = "exec firefox";

            "${mod}+s" = "exec ${snap} select";
            "${mod}+Shift+s" = "exec ${snap} screen";
            "${mod}+Mod1+s" = "exec ${snap} all";

            "${mod}+h" = "focus left";
            "${mod}+l" = "focus right";
            "${mod}+j" = "focus down";
            "${mod}+k" = "focus up";

            "${mod}+Shift+h" = "move left";
            "${mod}+Shift+l" = "move right";
            "${mod}+Shift+j" = "move down";
            "${mod}+Shift+k" = "move up";

            "${mod}+v" = "fullscreen toggle";
            "${mod}+Shift+v" = "floating toggle";

            "${mod}+Control+w" = "exec ${toggleWaybar}";
            "${mod}+Control+p" = "exec ${screenLock}";

            "${mod}+b" = "move scratchpad";
            "${mod}+Shift+b" = "scratchpad show";
            "${mod}+m" = "scratchpad show";

            "${mod}+Mod1+h" = "resize shrink width 20 px";
            "${mod}+Mod1+l" = "resize grow width 20 px";
            "${mod}+Mod1+j" = "resize grow height 20 px";
            "${mod}+Mod1+k" = "resize shrink height 20 px";

            "${mod}+i" = "exec brightnessctl set 10%-";
            "${mod}+bracketleft" = "exec brightnessctl set 10%+";
            "${mod}+Shift+o" = "exec ${toggleSound}";
            "${mod}+Shift+p" = "exec ${setSound100}";
            "${mod}+p" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+";
            "${mod}+o" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-";
          };
      };

    extraConfig = ''
      floating_modifier Mod4 normal
      bindsym --whole-window Mod4+button1 move
      bindsym --whole-window Mod4+button3 resize

      seat seat0 xcursor_theme Bibata-Modern-Ice 20
    '';
  };
}
