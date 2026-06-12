{
  description = "Aya eBPF Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      fenix,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      rustToolchain = fenix.packages.${system}.fromToolchainFile {
        file = ./rust-toolchain.toml;
        sha256 = "sha256-R3POfbXvE2Y9iN8v2+f80eTszmGfE6i7P97A+WunvIs=";
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          pkg-config
          clang
          llvmPackages.bintools
          bpftools
        ];

        buildInputs = with pkgs; [
          openssl
          libgit2
          libelf
          zlib
        ];

        shellHook = ''
          export CARGO_HOME="''${CARGO_HOME:-$HOME/.cargo}"
          export PATH="$CARGO_HOME/bin:$PATH"

          export OPENSSL_DIR="${pkgs.openssl.dev}"
          export OPENSSL_LIB_DIR="${pkgs.openssl.out}/lib"
          export OPENSSL_INCLUDE_DIR="${pkgs.openssl.dev}/include"
          export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"

          export BPF_CLANG_FLAGS="-I ${pkgs.linuxHeaders}/include"

          export CFLAGS="-fno-zero-call-used-regs=used-gpr -fno-stack-protector"
          export BPF_CLANG_FLAGS="-I ${pkgs.linuxHeaders}/include $CFLAGS"

          cargo-binstall bpf-linker
          cargo install cargo-generate

        '';
      };
    };
}
