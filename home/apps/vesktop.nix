{ ... }:

{
  programs.vesktop = {
    enable = true;

    settings = {
      appBadge = false;
      arRPC = true;
      checkUpdates = false;
      disableMinSize = true;
      minimizeToTray = false;
      tray = false;
      splashBackground = "#383838";
      splashColor = "#f7f7f7";
      splashTheming = true;
      staticTitle = true;
      hardwareAcceleration = true;
      discordBranch = "stable";
    };

    vencord = {
      settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        plugins = {
          FakeNitro.enabled = true;
          MessageLogger = {
            enable = true;
            ignoreSelf = true;
          };
        };
      };
    };
  };
}
