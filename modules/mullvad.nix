{ pkgs, ... }:

{
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  services.resolved.enable = true;

  environment.systemPackages = with pkgs; [
    mullvad-vpn
    mullvad-browser
  ];
}
