{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alsa-lib
    vulkan-loader
    vulkan-tools
    systemd.lib
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    libxkbcommon
    wayland
    libGL
  ];

  home.sessionVariables = {
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.vulkan-loader
      pkgs.xorg.libX11
      pkgs.xorg.libXcursor
      pkgs.xorg.libXi
      pkgs.xorg.libXrandr
      pkgs.libxkbcommon
      pkgs.wayland
      pkgs.libGL
    ];
  };
}
