{ hostName, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";

      ll = "eza -l";
      la = "eza -a";
      lla = "eza -la";
      ls = "eza";

      cat = "bat";
      cd = "z";
      grep = "rg";
      find = "fd";
      open = "xdg-open";
      ltree = "eza --tree";
      neofetch = "fastfetch";

      nixreb = "sudo nixos-rebuild switch --flake ~/git/flake#${hostName}";
      nixtest = "sudo nixos-rebuild test --flake .";
      nixboot = "sudo nixos-rebuild boot --flake ~/git/flake#${hostName}";
      nixupdate = "nix flake update";
      nixclear = "nix-collect-garbage -d";
      nixfull = "nixreb && homereb && nixclear";

      gst = "git status -sb";
      gs = "git status";
      ga = "git add";
      gc = "git commit -m";
      gp = "git push";

      ts = "tailscale";
      tst = "tailscale status";
      tsu = "tailscale up --ssh --operator=$USER";
      tsd = "tailscale down";

      homereb = "home-manager switch --flake ~/git/flake#${hostName}";

      k = "kubectl";

      unpack = "tar -xvf";

      cop = "wl-copy";
    };

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
        "kubectl"
      ];
      theme = "agnoster";
    };

    initContent = ''
            bindkey "^[[1;5C" forward-word
            bindkey "^[[1;5D" backward-word
            export EDITOR="nvim"
            export BROWSER="firefox"
            export TERMINAL="kitty"
      			export PATH="$HOME/.cargo/bin:$PATH"

            function devshell() {
                if [ -z "$1" ]; then
                    echo "Usage: devshell <shell-name>"
                    return 1
                fi
                nix develop ~/git/flake/devShells/$1
            }
    '';
  };
}
