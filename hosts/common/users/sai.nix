{
  pkgs,
  inputs,
  ...
}:

{
  users.users.sai = {
    initialHashedPassword = "$y$j9T$UUQb1d7dnvcgDOBRxll9P0$9YKlpeQa4lF///MfU2Awe1ttn3yxPsCtOVu219a42p8";
    isNormalUser = true;
    description = "Literally Sai";
    extraGroups = [
      "wheel"
      "render"
      "docker"
      "networkmanager"
      "audio"
      "video"
      "plugdev"
      "input"
      "kvm"
      "libvirtd"
      "qemu-libvirtd"
    ];
    openssh.authorizedKeys.keys = [ ];
    packages = [ inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
