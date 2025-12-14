{ pkgs, ... }:

{
  services.hypridle = {
    enable = true;
    package = pkgs.hypridle;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
      };

      listener = [
        {
          timeout = 1200;
          on-timeout = "${pkgs.playerctl}/bin/playerctl -a status | grep -q Playing || hyprlock";
        }
        {
          timeout = 1800;
          on-timeout = "${pkgs.playerctl}/bin/playerctl -a status | grep -q Playing || hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 2400;
          on-timeout = "${pkgs.playerctl}/bin/playerctl -a status | grep -q Playing || systemctl suspend";
          on-resume = "${pkgs.dunst}/bin/dunstify 'Welcome Back!'";
        }
      ];
    };
  };

  home.packages = [ pkgs.playerctl ];
}
