{ pkgs, ... }:

{

  home.packages = with pkgs; [
    black
    nixfmt
    prettierd
    shfmt
    stylua
    yamlfmt
    hclfmt
  ];
}
