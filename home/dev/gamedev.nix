{ pkgs, ...}:

{
  home.packages = with pkgs; [
    tiled
  ];
}
