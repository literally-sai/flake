{ hostName, ... }:

let
  files = builtins.readDir ./.;
  excludedOllam = "ollama.nix";
  excludeSteam = "steam.nix";

  nixFiles = builtins.filter (
    name:
    name != "default.nix"
    && builtins.match ".*\\.nix" name != null
    && (hostName != "murgo" || name != excludedOllam)
    && (hostName != "murgo" || name != excludeSteam)
  ) (builtins.attrNames files);
  imports = map (name: ./. + "/${name}") nixFiles;
in
{
  imports = imports;
}
