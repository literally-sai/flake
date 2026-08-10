{ pkgs, hostName, lib, ... }:
let
  files = builtins.readDir ./.;
  nixFiles = builtins.filter (name: name != "default.nix" && builtins.match ".*\\.nix" name != null) (
    builtins.attrNames files
  );
  imports = map (name: ./. + "/${name}") nixFiles;
in
{
  imports = imports;
  home.packages =
    with pkgs;
    [
      discord
      zathura
      zathuraPkgs.zathura_pdf_mupdf
      zathuraPkgs.zathura_pdf_poppler
      blender
      pavucontrol
      obsidian
      freecad
      playerctl
      pulsemixer
      papers
      google-chrome
      telegram-desktop
    ]
    ++ lib.optionals (hostName == "ghylak") [
      bambu-studio
    ];
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
    ];
  };
}
