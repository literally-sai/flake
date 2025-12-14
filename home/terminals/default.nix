{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
    ghostty
  ];

  imports = [
    ./ghostty.nix
    ./kitty.nix
  ];
}
