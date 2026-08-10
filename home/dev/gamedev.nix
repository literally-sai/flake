{ pkgs, ...}:

{
  home.packages = with pkgs; [
    tiled
    ppsspp 
    bevy-cli
    vulkan-tools
  ];
}
