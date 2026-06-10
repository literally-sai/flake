{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    settings = {
      preview = {
        tab_size = 4;
        max_width = 1920;
        max_height = 1080;
        image_quality = 90;
      };
    };
  };
}
