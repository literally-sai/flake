{ ... }:

{
  services.mullvad-vpn = {
    enable = true;
    gui.enable = true;
  };

  services.resolved.enable = true;
}
