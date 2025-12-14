{ ... }:

{
  home = {
    username = "sai";
    homeDirectory = "/home/sai";
    stateVersion = "25.05";
  };

  imports = [
    ./apps
    ./cli
    ./desktop
    ./terminals
    ./development
    ./rice
    ./scripts
  ];
}
