{ pkgs, ... }:

let
  background = ../resources/sddm.png;
in
{
  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      theme = "sddm-astronaut-theme";
      package = pkgs.kdePackages.sddm;

      extraPackages = with pkgs; [
        (sddm-astronaut.override {
          embeddedTheme = "pixel_sakura_static";
          themeConfig = {
            Background = "${background}";
            ScreenWidth = 1920;
            ScreenHeight = 1080;
            blur = false;
            FormPosition = "left";

            BackgroundColor = "#141821";
            DimBackgroundColor = "#10131A";
            FormBackgroundColor = "#1B1E25";

            DateTextColor = "#93A4B5";
            TimeTextColor = "#E6EDF3";

            PlaceholderTextColor = "#A9B4BF";

            LoginFieldBackgroundColor = "#d4d9e9ff";
            PasswordFieldBackgroundColor = "#d4d9e9ff";
            LoginFieldTextColor = "#E2B714";
            PasswordFieldTextColor = "#E2B714";

            UserIconColor = "#E2B714";
            PasswordIconColor = "#E2B714";

            SessionButtonTextColor = "#93A4B5";

            HighlightBackgroundColor = "#E2B714";
            HighlightTextColor = "#0E1117";
            HighlightBorderColor = "transparent";

            HoverSessionButtonTextColor = "#F3CC26";

            WarningColor = "#D6A50F";
          };
        })
      ];
    };

    xserver = {
      enable = true;
      xkb.layout = "us";
    };
  };

  environment.systemPackages = with pkgs; [
    jq
    (sddm-astronaut.override {
      themeConfig = {
        background = "${background}";
        ScreenWidth = 1920;
        ScreenHeight = 1080;
        blur = false;
      };
    })
  ];
}
