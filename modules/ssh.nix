{ ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
      AllowUsers = [ "sai" ];
      PermitRootLogin = "prohibit-password";
      X11Forwarding = false;
      KbdInteractiveAuthentication = false;
      ChallengeResponseAuthentication = false;
    };
  };
}
