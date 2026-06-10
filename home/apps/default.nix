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
    discord
    zathura
    blender
    obs-studio
    pavucontrol
    obsidian
		freecad
    playerctl
    pulsemixer
		papers
		bambu-studio
  ];
}
