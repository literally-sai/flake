{
  pkgs,
  lib,
  ...
}:
let
  toolchain = pkgs.rust-bin.nightly."2026-05-01".default.override {
    extensions = [
      "rust-src"
      "rust-analyzer"
      "clippy"
      "rustfmt"
    ];
    targets = [ "wasm32-unknown-unknown" ];
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

  buildLibs = with pkgs; [
    openssl
    libgit2
    elfutils
    zlib
    libbpf
  ];
  foreignBinaryLibs = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    zstd
    libffi
  ];
  ldLibs = runtimeLibs ++ buildLibs ++ foreignBinaryLibs;

  pkgConfigLibs = runtimeLibs ++ buildLibs;

  envVars = {
    LD_LIBRARY_PATH = lib.makeLibraryPath ldLibs;
    RUST_SRC_PATH = "${toolchain}/lib/rustlib/src/rust/library";
    LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
    PKG_CONFIG_PATH =
      "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" pkgConfigLibs}"
      + "\${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}";
    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
    BPF_CLANG_FLAGS = "-I ${pkgs.linuxHeaders}/include";
    BCC_KERNEL_SOURCE = "${pkgs.linuxHeaders}";
  };

  envScript = ''
    if [ -z "''${__DEV_LANGS_ENV_LOADED:-}" ]; then
      export __DEV_LANGS_ENV_LOADED=1
  ''
  + lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: ''export ${n}="${v}"'') envVars)
  + ''

    fi
  '';
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
    wasm-bindgen-cli
    binaryen
  ]);

  home.sessionVariables = envVars;

  home.file.".config/dev-langs-env.sh".text = envScript;

  programs.zsh.envExtra = envScript;
  programs.bash.initExtra = envScript;
  programs.fish.shellInit = ''
    if not set -q __DEV_LANGS_ENV_LOADED
      bash -c 'true'
    end
  '';

  home.file.".cargo/config.toml".text = ''
    [env]
    PKG_CONFIG_PATH = { value = "${
      lib.makeSearchPathOutput "dev" "lib/pkgconfig" pkgConfigLibs
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
