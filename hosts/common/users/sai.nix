{
  pkgs,
  inputs,
  ...
}:

{
  users.users.sai = {
    initialHashedPassword = "$y$j9T$9B6fOy9l/7mohqmyGI3uA.$3DwseJoMJIHP6vze5HpS/PsEY2UuLiaI6j/SRp0lgJ8";
    isNormalUser = true;
    description = "sai";
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
      "dialout"
      "storage"
      "wireshark"
    ];
    packages = [ inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
