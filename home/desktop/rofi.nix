{
  config,
  ...
}:

{
  programs.rofi = {
    enable = true;
    theme = "${config.home.homeDirectory}/.config/rice/current/rofi.rasi";
  };
}
