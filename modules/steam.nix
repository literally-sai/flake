{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };


  users.extraGroups.steam.members = [ "sai" ];

  environment.systemPackages = with pkgs; [
    steam
    steam-run
    wineWow64Packages.stable
    lutris
    winetricks
    protontricks
    gamemode
    mangohud
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
