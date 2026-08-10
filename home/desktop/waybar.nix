{
  pkgs,
  lib,
  palette,
  hostName,
  ...
}:

let
  isLaptop = lib.toLower hostName == "murgo";

  dispatch = expr: "hyprctl dispatch '${expr}'";
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.main = {
      layer = "top";
      position = "top";
      height = 42;
      spacing = 0;
      reload_style_on_change = true;

      modules-left = [
        "custom/os"
        "hyprland/workspaces"
        "hyprland/submap"
      ];

      modules-center = [
        "hyprland/window"
        "mpris"
      ];

      modules-right = [
        "privacy"
        "custom/todo"
        "idle_inhibitor"
        "tray"
        "pulseaudio"
        "bluetooth"
        "network"
      ]
      ++ lib.optionals isLaptop [
        "backlight"
        "battery"
      ]
      ++ [ "clock" ];

      "custom/os" = {
        format = "󱄅";
        tooltip = false;
        on-click = "powermenu";
        on-click-right = "theme-changer next";
      };

      "hyprland/workspaces" = {
        format = "{name}";
        on-click = "activate";
        all-outputs = false;
        sort-by-number = true;
        show-special = true;
        special-visible-only = true;
        on-scroll-up = dispatch ''hl.dsp.focus({ workspace = "e+1" })'';
        on-scroll-down = dispatch ''hl.dsp.focus({ workspace = "e-1" })'';
      };

      "hyprland/submap" = {
        format = "󰘳  {}";
        tooltip = false;
      };

      "hyprland/window" = {
        format = "{title}";
        max-length = 44;
        separate-outputs = true;
        icon = true;
        icon-size = 15;
        rewrite = {
          "(.*) — Mozilla Firefox" = "$1";
          "(.*) - Mozilla Firefox" = "$1";
          "(.*) - NVIM" = "$1";
          "^$" = "desktop";
        };
      };

      mpris = {
        format = "{player_icon}  {dynamic}";
        format-paused = "{status_icon}  {dynamic}";
        dynamic-order = [
          "title"
          "artist"
        ];
        dynamic-len = 34;
        interval = 1;
        player-icons = {
          default = "󰎇";
          spotify = "󰓇";
          firefox = "󰈹";
          mpv = "󰐹";
        };
        status-icons = {
          playing = "󰐊";
          paused = "󰏤";
          stopped = "󰓛";
        };
        on-click = "playerctl play-pause";
        on-click-right = "playerctl next";
        on-scroll-up = "playerctl volume 0.05+";
        on-scroll-down = "playerctl volume 0.05-";
      };

      privacy = {
        icon-spacing = 6;
        icon-size = 13;
        transition-duration = 250;
        modules = [
          {
            type = "screenshare";
            tooltip = true;
          }
          {
            type = "audio-in";
            tooltip = true;
          }
        ];
      };

      "custom/todo" = {
        exec = "todo bar";
        return-type = "json";
        interval = 900;
        signal = 9;
        format = "{}";
        on-click = "todo menu";
        on-click-right = "todo add";
        on-click-middle = "todo clear";
      };

      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "󰈈";
          deactivated = "󰈉";
        };
        tooltip-format-activated = "idle inhibited";
        tooltip-format-deactivated = "idle allowed";
      };

      tray = {
        icon-size = 15;
        spacing = 10;
        show-passive-items = true;
      };

      pulseaudio = {
        format = "{icon}  {volume}%";
        format-muted = "󰝟";
        format-bluetooth = "󰥰  {volume}%";
        format-bluetooth-muted = "󰝟";
        format-icons = {
          headphone = "󰋋";
          headset = "󰋎";
          default = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
        };
        scroll-step = 5;
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
        tooltip-format = "{desc}";
      };

      bluetooth = {
        format = "󰂯";
        format-disabled = "󰂲";
        format-off = "󰂲";
        format-connected = "󰂱";
        tooltip-format = "{controller_alias}";
        tooltip-format-connected = "{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}";
        on-click = "blueman-manager";
      };

      network = {
        format-wifi = "{icon}";
        format-ethernet = "󰈀";
        format-linked = "󰤩";
        format-disconnected = "󰤮";
        format-icons = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        interval = 5;
        tooltip-format-wifi = "{essid}  {signalStrength}%\n{ipaddr}";
        tooltip-format-ethernet = "{ifname}\n{ipaddr}";
        tooltip-format-disconnected = "offline";
        on-click = "${pkgs.kitty}/bin/kitty --title nmtui -e nmtui";
      };

      backlight = {
        format = "󰃟  {percent}%";
        scroll-step = 5;
        tooltip = false;
      };

      battery = {
        states = {
          warning = 25;
          critical = 12;
        };
        format = "{icon}  {capacity}%";
        format-charging = "󰂄  {capacity}%";
        format-plugged = "󰚥  {capacity}%";
        format-full = "󰁹  {capacity}%";
        format-icons = [
          "󰁺"
          "󰁼"
          "󰁾"
          "󰂀"
          "󰂂"
          "󰁹"
        ];
        interval = 15;
        tooltip-format = "{timeTo}";
      };

      clock = {
        format = "{:%H:%M}";
        format-alt = "{:%a %d %b}";
        tooltip-format = "<span font='${palette.font.mono} 11'>{calendar}</span>";
        calendar = {
          mode = "month";
          mode-mon-col = 3;
          weeks-pos = "right";
          on-scroll = 1;
          format = {
            months = "<span color='${palette.text}'><b>{}</b></span>";
            days = "<span color='${palette.subtext}'>{}</span>";
            weeks = "<span color='${palette.accent2}'><b>W{}</b></span>";
            weekdays = "<span color='${palette.gold}'><b>{}</b></span>";
            today = "<span color='${palette.accent}'><b><u>{}</u></b></span>";
          };
        };
        actions = {
          on-click-right = "mode";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };
    };

    style = null;
  };
}
