{
  config,
  pkgs,
  ...
}:

let
  background = "${config.home.homeDirectory}/.config/rice/current/lockpaper.png";
in
{
  programs.hyprlock = {
    enable = true;

    extraConfig = ''
            general {
                disable_loading_bar = true
                grace = 0
                hide_cursor = true
                no_fade_in = false
                ignore_empty_password = true
            }

            background {
                monitor =
                path = ${background}
                blur_passes = 2
                blur_size = 2
                noise = 0.0117
                contrast = 1.3
                brightness = 0.8
                vibrancy = 0.21
                vibrancy_darkness = 0.0
            }

            input-field {
                monitor =
                size = 200, 60
                outline_thickness = 2
                dots_size = 0.3
                dots_spacing = 0.15
                dots_center = true
                outer_color = rgb(cba6f7)
                inner_color = rgb(cba6f7)
                font_color = rgb(cdd6f4)
                fade_on_empty = true
                rounding = 10
                placeholder_text = <i><span foreground="##b4befe">Password...</span></i>

                position = 0, -150
                halign = center
                valign = center
            }

            label {
                monitor =
                text = cmd[update:1000] date "+%H:%M"
                color = rgba(b4befeee)
                font_size = 100
                font_family = JetBrainsMono Nerd Font
                position = 0, 240
                halign = center
                valign = center
      	  shadow_passes = 1
                shadow_range = 12
                shadow_boost = 1.5
                shadow_color = rgb(000000)
            }

            label {
                monitor =
                text = cmd[update:1000] date "+%A, %-d %B %Y"
                color = rgba(94e2d5ee)
                font_size = 25
                font_family = JetBrainsMono Nerd Font
                position = 0, 150
                halign = center
                valign = center
      	  shadow_passes = 1
                shadow_range = 12
                shadow_boost = 1.5
                shadow_color = rgb(000000)
            }
    '';
  };
}
