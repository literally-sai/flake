{ pkgs, ... }:

{
  home.packages = with pkgs; [
    golangci-lint
    markdownlint-cli
  ];
}
