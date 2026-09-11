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

  users.users.sai.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIELNuUIttfinxzlGv8ohp+lvn4ePIZbeeY3E9Nayv5H8 sai@ghylak"
    "ssh-ed25519 AAAAC3NzaC1lZDI1lZDI1NTE5AAAAIHXCHK9kugb3a+r/IGdSyHCExjjQxZSm45JfulbgFo5N sai@murgo"
  ];
}
