{
  description = "bevy flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
    bevy_cli.url = "github:TheBevyFlock/bevy_cli";
  };

  outputs =
    {
      nixpkgs,
      rust-overlay,
      flake-utils,
      bevy_cli,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShells.default =
          with pkgs;
          mkShell {
            buildInputs = [
              (rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; })
              pkg-config
              clang
              mold
              bevy_cli.packages.${system}.default
            ]
            ++ lib.optionals (lib.strings.hasInfix "linux" system) [
              alsa-lib
              vulkan-loader
              vulkan-tools
              libudev-zero
              libx11
              libxcursor
              libxi
              libxrandr
              libxkbcommon
              wayland
            ];
            RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
            LD_LIBRARY_PATH = lib.makeLibraryPath [
              vulkan-loader
              libx11
              libxi
              libxcursor
              libxkbcommon
              wayland
            ];
          };
      }
    );
}
