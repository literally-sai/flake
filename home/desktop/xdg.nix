{ pkgs, ... }:

{
  home.packages = with pkgs; [
    xdg-desktop-portal-gtk
  ];

  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "gtk";
    };
  };
}
