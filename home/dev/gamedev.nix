{ pkgs, ...}:

{
  home.packages = with pkgs; [
    tiled
    # this is just for extracting old models from psp games
    # not for playing games lol
    ppsspp 
  ];
}
