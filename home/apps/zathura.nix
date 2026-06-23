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
    };

    extraConfig = ''
      map i recolor
      map j feedkeys "<C-Down>"
      map k feedkeys "<C-Up>"
      map r reload
    '';
  };
}
