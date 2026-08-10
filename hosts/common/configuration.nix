{
  hostName,
  inputs,
  pkgs,
  ...
}:

let
  zfsHostId = if hostName == "ghylak" then "deadc0de" else "ea7bee5";
in
{
  imports = [ ../${hostName}/hardware.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "${hostName}";
  networking.hostId = "${zfsHostId}";
  networking.networkmanager.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
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

  programs.hyprland = {
    enable = true;
  };

  nixpkgs.overlays = [
    inputs.rust-overlay.overlays.default
    (final: prev: {
      bevy-cli = inputs.bevy_cli.packages.${prev.stdenv.hostPlatform.system}.default;
    })
  ];

  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        mesa
        vulkan-tools
        vulkan-validation-layers
      ];
      enable32Bit = true;
    };
    amdgpu.opencl.enable = true;
  };

  systemd.settings.Manager.DefaultTimeoutStopSec = 10;
  services.journald.extraConfig = "SystemMaxUse=300M";

  security.polkit.enable = true;
  services.dbus.enable = true;

  system.stateVersion = "26.05";
}
