{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bpftools
    bpftrace
    bpf-linker
    (python3.withPackages (ps: with ps; [ pip bcc ]))
  ];
}
