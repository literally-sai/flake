{ pkgs, ... }:

{
  programs.zathura = {
    enable = true;

    options = {
      adjust-open = "best";

      guioptions = "none";
      selection-clipboard = "clipboard";
      synctex = true;
      synctex-editor-command = "nvr --remote-silent +%{line} %{input}";

      recolor = true;
      recolor-keephue = true;

      recolor-lightcolor = "#00000000";
      recolor-darkcolor = "#E0E0E0";

      default-bg = "rgba(0, 0, 0, 0)";
      default-fg = "#E0E0E0";
      statusbar-bg = "rgba(0, 0, 0, 0)";
      statusbar-fg = "#E0E0E0";
    };

    extraConfig = ''
      map i recolor
      map j feedkeys "<C-Down>"
      map k feedkeys "<C-Up>"
      map r reload
    '';
  };
}
