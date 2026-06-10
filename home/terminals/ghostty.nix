{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size = 14;
      theme = "Aardvark Blue";
      background-opacity = 0.7;
      window-vsync = false;
      window-height = 35;
      window-width = 135;
      window-padding-x = 10;
      gtk-titlebar-style = "tabs";
      window-inherit-font-size = true;
      keybind = [ "ctrl+v=paste_from_clipboard" ];
      bold-is-bright = true;
      cursor-style = "bar";
      cursor-opacity = 0.8;
      link-url = true;
      confirm-close-surface = false;
      background-blur = true;
      shell-integration-features = "cursor,sudo,title";
    };
  };
}
