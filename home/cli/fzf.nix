{ ... }:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --E .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--margin=1"
      "--padding=1"
      "--preview='bat --color=always -n {}'"
      "--bind 'ctrl-/:toggle-preview'"
    ];
  };
}
