{ pkgs, ... }:

{
  home.packages = with pkgs; [
    lexend
    roboto
    rubik
    material-design-icons
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    papirus-icon-theme
  ];
}
