{ pkgs, ... }:

{
  home.packages = with pkgs; [
    go
    lua
    gleam
    erlang
    nodejs_24
	];
}
