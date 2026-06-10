{ hostName, pkgs, ... }:

let
  hostDir = if hostName == "Ghylak" then "ghylak" else "murgo";
	zfsHostId = if hostName == "Ghylak" then "deadc0de" else "ea7bee5";
in
{
  imports = [ ../${hostDir}/hardware.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "${hostName}";
	networking.hostId = "${zfsHostId}";
  networking.networkmanager.enable = true;

  services = {
    pipewire.wireplumber.enable = true;
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
      vulkan-tools
    ];
  };

  system.stateVersion = "26.05";
}
