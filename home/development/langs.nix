{ pkgs, ... }:

{
  home.packages = with pkgs; [
    clang
    rustup
    go
    gleam
    erlang
    nodejs_24
    premake5
    protobuf
  ];
}
