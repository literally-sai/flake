{ hostName, lib, ... }:

{
  programs.waybar = {
    enable = true;
    style = null;
    settings.bar = {
      layer = "top";
      position = "top";
      reload_style_on_change = true;
      height = 20;

      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "group/middle" ];
      modules-right = [ "group/right" ];

      "hyprland/workspaces" = {
        format = "{name}";
        on-click = "activate";
      };

      "hyprland/window" = {
        format = "    {}";
        max-length = 22;
        separate-outputs = true;
      };

      "custom/spotify" = {
        format = "";
        interval = 5;
        exec = "echo ";
        exec-if = "pgrep spotify";
      };

      "custom/discord" = {
        format = "";
        interval = 5;
        exec = "echo ";
        exec-if = "pgrep -f vesktop";
      };

      "custom/steam" = {
        format = "";
        interval = 5;
        exec = "echo ";
        exec-if = "pgrep steam";
      };

      "custom/recorder" = {
        format = "";
        interval = 5;
        exec = "echo ";
        exec-if = "pgrep wf-recorder";
      };

      "group/middle" = {
        orientation = "horizontal";
        modules = [
          "hyprland/window"
          "custom/spotify"
          "custom/discord"
          "custom/steam"
          "custom/recorder"
        ];
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-bluetooth = "󰥰 {volume}%";
        format-bluetooth-muted = "󰝟 ";
        format-muted = "󰝟 ";
        format-icons = {
          default = [
            "󰕿 "
            "󰖀 "
            "󰕾 "
          ];
          headphone = "󰋋 ";
        };
      };

      bluetooth = {
        format = "󰂯";
        format-disabled = "󰂲";
        format-connected = "󰂱";
        format-connected-battery = "󰂱";
      };

      network = {
        format = "{icon} ";
        format-icons = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        format-linked = "󰤩 ";
        format-ethernet = "󰈀 ";
        format-disconnected = "󰤮 ";
      };

      battery = {
        states = {
          warning = 20;
          critical = 10;
        };
        format = "{icon} ";
        format-charging = " ";
        format-full = " ";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
      };

      clock = {
        format = "{:%H:%M}";
      };

      "group/right" = {
        orientation = "horizontal";
        modules = [
          "pulseaudio"
          "bluetooth"
          "network"
        ]
        ++ lib.optional (hostName == "Murgo") "battery"
        ++ [
          "clock"
        ];
      };

    };
  };
}
