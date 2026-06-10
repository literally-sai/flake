{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (callPackage ./snap.nix { })
    (callPackage ./theme-changer.nix { })
  ];
}
