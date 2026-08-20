{ pkgs, lib, ... }:
let
  toolchain = pkgs.rust-bin.nightly."2026-05-01".default.override {
    extensions = [
      "rust-src"
      "rust-analyzer"
      "clippy"
      "rustfmt"
    ];
  };

  runtimeLibs = with pkgs; [
    vulkan-loader
    libxkbcommon
    wayland
    alsa-lib
    systemdLibs
    libX11
    libXcursor
    libXi
    libXrandr
  ];

  devLibs =
    runtimeLibs
    ++ (with pkgs; [
      openssl
      libgit2
      elfutils
      zlib
      libbpf
    ]);
in
{
  home.packages = [
    toolchain
  ]
  ++ (with pkgs; [
    pkg-config
    clang
    mold
    cargo-generate
  ]);

  home.sessionVariables = {
    RUST_SRC_PATH = "${toolchain}/lib/rustlib/src/rust/library";
    LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";

    PKG_CONFIG_PATH =
      "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" devLibs}"
      + "\${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}";

    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
    BPF_CLANG_FLAGS = "-I ${pkgs.linuxHeaders}/include";
    BCC_KERNEL_SOURCE = "${pkgs.linuxHeaders}";
  };

  home.file.".cargo/config.toml".text = ''
    [env]
    PKG_CONFIG_PATH = { value = "${
      lib.makeSearchPathOutput "dev" "lib/pkgconfig" devLibs
    }", force = false }
    LIBCLANG_PATH = { value = "${pkgs.llvmPackages.libclang.lib}/lib", force = false }

    [target.x86_64-unknown-linux-gnu]
    linker = "clang"
    rustflags = [
      "-C", "link-arg=-fuse-ld=mold",
      "-C", "link-arg=-Wl,-rpath,${lib.makeLibraryPath runtimeLibs}",
    ]
  '';
}
