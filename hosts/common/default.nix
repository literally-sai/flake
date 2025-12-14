{
  lib,
  inputs,
  pkgs,
  ...
}:

{
  imports = [ ./users ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "sai"
      ];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    registry = lib.mapAttrs (_: flake: { inherit flake; }) inputs;
  };
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
}
