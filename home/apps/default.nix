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
    vencord
    discord
    vesktop
    mcomix
    zathura
    blender
    obs-studio
    pavucontrol
    obsidian
    playerctl
    pulsemixer
    wireplumber
  ];
}
