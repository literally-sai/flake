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
    libbpf
    cargo-binstall
    gdb
    valgrind
    cmake
    gnumake
    premake5
    nodejs_24
    tcpdump
    ninja
    localstack
  ];
}
