{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  users.extraGroups.steam.members = [ "sai" ];

  environment.systemPackages = with pkgs; [
    steam
    steam-run
    wineWowPackages.stable
    lutris
    winetricks
    protontricks
    gamemode
    mangohud
    vulkan-tools
    vulkan-loader
    vulkan-headers
    vulkan-validation-layers
    libstrangle
    piper
    portaudio
    alsa-lib
    libglvnd
  ];
}
