{ pkgs, ... }:

{
  services.hyprsunset = {
    enable = true;

    settings.profile = [
      {
        time = "6:00";
        temperature = 6000;
      }
      {
        time = "22:00";
        temperature = 4000;
      }
    ];

    package = pkgs.hyprsunset;
  };
}
