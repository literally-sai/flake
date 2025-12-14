{ config, ... }:

{
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
        53317
      ];
      allowedUDPPorts = [ 53317 ];
    };

    useDHCP = false;
    dhcpcd.enable = false;

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
  };
}
