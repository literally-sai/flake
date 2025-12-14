{ inputs, pkgs, ... }:

{
home.packages = [ inputs.vermvim.packages.${pkgs.stdenv.hostPlatform.system}.default ];
}
