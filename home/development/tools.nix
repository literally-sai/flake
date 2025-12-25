{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tiled
    udev.dev
    ntfs3g
    gdb
    valgrind
    cmake
    gnumake
  ];
}
