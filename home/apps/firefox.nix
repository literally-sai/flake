{ pkgs, ... }:

let
  commonExtensions = with pkgs.nur.repos.rycee.firefox-addons; [
    ublock-origin
    onepassword-password-manager
  ];
in
{
  home.file.".local/share/applications/firefox-work.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Firefox Work
    Exec=firefox -P work
    Icon=firefox
    Terminal=false
    Categories=Network;WebBrowser;
    StartupNotify=true
  '';

  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        isDefault = true;
        settings = {
          "middlemouse.paste" = false;
        };
        extensions.packages = commonExtensions;
      };
      work = {
        id = 1;
        extensions.packages = commonExtensions;
      };
    };
  };
}
