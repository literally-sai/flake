{ ... }:

{
  home = {
    username = "sai";
    homeDirectory = "/home/sai";
    stateVersion = "26.05";
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
