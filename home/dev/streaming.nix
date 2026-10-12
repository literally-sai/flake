{ pkgs, ...}:

{
  home.packages = with pkgs; [
    inochi-creator
    inochi-session
  ];
}
