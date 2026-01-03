{ pkgs, ... }:

{
  home.packages = with pkgs; [
    clang
    rustup
    go
    lua
    gleam
    erlang
    nodejs_24
    premake5
    protobuf
  ];
}
