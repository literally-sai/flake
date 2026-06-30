{ hostName, ... }:

let
  files = builtins.readDir ./.;
  excludedFile = "ollama.nix";

  nixFiles = builtins.filter (
    name:
    name != "default.nix"
    && builtins.match ".*\\.nix" name != null
    && (hostName != "murgo" || name != excludedFile)
  ) (builtins.attrNames files);
  imports = map (name: ./. + "/${name}") nixFiles;
in
{
  imports = imports;
}
