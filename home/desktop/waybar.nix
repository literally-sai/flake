{ hostName, lib, ... }:

{
  programs.waybar = {
    enable = true;
    style = null;
    settings.bar = {
      layer = "top";
      position = "top";
      reload_style_on_change = true;
      height = 25;

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
        on-double-click = "theme-changer next";
      };

      "custom/spotify" = {
        format = "";
        tooltip = false;
        interval = 5;
        exec = "echo ";
        exec-if = "pgrep spotify";
      };

      "custom/discord" = {
        format = "";
        tooltip = false;
        interval = 5;
        exec = "echo ";
        exec-if = "pgrep -f vesktop";
      };

      "custom/steam" = {
        format = "";
        tooltip = false;
        interval = 5;
        exec = "echo ";
        exec-if = "pgrep steam";
      };

      "custom/recorder" = {
        format = "";
        tooltip = false;
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
        format-bluetooth = "󰥰  {volume}%";
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
        tooltip = false;
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
        tooltip = false;
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
