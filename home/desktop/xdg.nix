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
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "firefox.desktop";
        "image/avif" = "firefox.desktop";
        "image/bmp" = "firefox.desktop";
        "image/gif" = "firefox.desktop";
        "image/heic" = "firefox.desktop";
        "image/heif" = "firefox.desktop";
        "image/jp2" = "firefox.desktop";
        "image/jpeg" = "firefox.desktop";
        "image/jpg" = "firefox.desktop";
        "image/jxl" = "firefox.desktop";
        "image/png" = "firefox.desktop";
        "image/svg+xml" = "firefox.desktop";
        "image/tiff" = "firefox.desktop";
        "image/webp" = "firefox.desktop";
        "image/x-bmp" = "firefox.desktop";
      };
    };
  };
}
