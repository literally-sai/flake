{ pkgs, ... }:

{
  programs.zathura = {
    enable = true;

    options = {
      recolor-lightcolor = "rgba(0, 0, 0, 1.0)";
      recolor-darkcolor = "rgba(255, 255, 255, 1.0)";
      recolor = "true";
      recolor-keephue = "true";

      adjust-open = "best";

      guioptions = "none";
      selection-clipboard = "clipboard";
      synctex = true;
      synctex-editor-command = "nvr --remote-silent +%{line} %{input}";
    };

    extraConfig = ''
      map i recolor
      map j feedkeys "<C-Down>"
      map k feedkeys "<C-Up>"
      map r reload
    '';
  };
}
