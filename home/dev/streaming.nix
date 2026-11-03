{ pkgs, ...}:

{
  home.packages = with pkgs; [
    inochi-session
    openseeface
  ];
}
