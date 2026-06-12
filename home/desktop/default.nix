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
    grim
    slurp
    waypipe
    wf-recorder
    wl-mirror
    wl-clipboard
    ffmpeg_7-full
    wtype
    autorandr
    imagemagick
    bibata-cursors
    brightnessctl
    dunst
    grim
    bibata-cursors
		openssl.dev
    localsend
    vlc
    autotiling
  ];
}
