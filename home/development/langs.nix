{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    rustup
    go
    gleam
    erlang
    nodejs_24
    premake5
    protobuf
  ];
}
