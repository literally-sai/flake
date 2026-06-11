{ config, ... }:

{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };

      background = [
        {
          monitor = "";
          path = "${config.home.homeDirectory}/.config/rice/current/lockpaper.png";
          blur_passes = 2;
          blur_size = 7;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "300, 50";
          position = "0, -120";
          halign = "center";
          valign = "center";

          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;

          outer_color = "rgb(15, 15, 15)";
          inner_color = "rgb(200, 200, 200)";
          font_color = "rgb(10, 10, 10)";
          fade_on_empty = false;
          placeholder_text = "<i>Enter Password...</i>";
          hide_input = false;
        }
      ];
    };
  };
}
