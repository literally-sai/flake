{ pkgs, ... }:

{
  home.packages = with pkgs; [
    alsa-lib
    vulkan-loader
    vulkan-tools
    libX11
    libXcursor
    libXi
    libXrandr
    libxkbcommon
    wayland
    libGL
    openssl.dev
  ];

  home.sessionVariables = {
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.vulkan-loader
      pkgs.libX11
      pkgs.libXcursor
      pkgs.libXi
      pkgs.libXrandr
      pkgs.libxkbcommon
      pkgs.wayland
      pkgs.libGL
      pkgs.openssl
    ];
  };
}
