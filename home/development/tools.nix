{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tiled
    love
    udev.dev
    ntfs3g
    gdb
    valgrind
    cmake
    gnumake
    premake5
    postgresql
    protobuf
    pkg-config
  ];
}
