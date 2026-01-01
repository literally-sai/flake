{ pkgs, ... }:
let
  files = builtins.readDir ./.;
  nixFiles = builtins.filter (name: name != "default.nix" && builtins.match ".*\\.nix" name != null) (
    builtins.attrNames files
  );
  imports = map (name: ./. + "/${name}") nixFiles;
in
{

  imports = imports;

  home.packages = with pkgs; [
    imwheel
    grim
    slurp
    waypipe
    wf-recorder
    wl-mirror
    wl-clipboard
    wtype
    hypridle
    hyprlock
    hyprpicker
    autorandr
    imagemagick
    bibata-cursors
    brightnessctl
    dunst
    grim
    bibata-cursors
    localsend
  ];
}
