{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bash
    awscli2
    aws-vault
    ssm-session-manager-plugin

    udev.dev
    ntfs3g
    postgresql
    protobuf
    pkg-config

    clang
    rustup
    bpftools
    libbpf
    cargo-binstall
    python3
    gdb
    valgrind
    cmake
    gnumake
    premake5
    nodejs_24
    tcpdump
  ];
}
