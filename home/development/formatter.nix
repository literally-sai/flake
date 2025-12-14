{ pkgs, ... }:

{

  home.packages = with pkgs; [
    black
    nixfmt-rfc-style
    prettierd
    shfmt
    stylua
    yamlfmt
    hclfmt
  ];
}
