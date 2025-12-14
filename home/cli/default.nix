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
    bat
    file
    git
    eza
    tree
    unzip
    exiftool
    wl-clipboard
    todo
    zip
    yazi
    ripgrep
    openvpn
    git
    gh
    bluez
    bluez-tools
    bluez-alsa
    networkmanager
    usbutils
    nix-prefetch
    home-manager
    fd
    btop
    jq
    procs
    tldr
    rusty-man
  ];
}
