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
    python315
  ];
}
