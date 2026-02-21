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
    python313
    python313.pkgs.pip
  ];
}
