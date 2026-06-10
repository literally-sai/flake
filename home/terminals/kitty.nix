{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
  ];

  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    settings = {
      copy_on_select = "yes";
      cursorShape = "beam";
      cursorBlink = "on";
      cursor_blink_interval = "1.3 ease-in-out";

      scrollback_lines = 1000;
      wheel_scroll_multiplier = "10.0";

      confirm_os_window_close = 0;

      enable_audio_bell = false;

      tab_bar_style = "powerline";
      tab_bar_edge = "top";
    };

    keybindings = {
      "ctrl+shift+equal" = "change_font_size all +2.0";
      "ctrl+shift+minus" = "change_font_size all -2.0";
    };

    extraConfig = ''
      include ~/.config/rice/current/kitty.conf
    '';
  };
}
