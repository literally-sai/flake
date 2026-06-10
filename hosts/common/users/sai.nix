{
  pkgs,
  inputs,
  ...
}:

{
  users.users.sai = {
    initialHashedPassword = "$y$j9T$GVELLSbxwJRxvZzwVemgk/$bKqeK9EdOohyI7oViTvVcdcj2XERlIU8q5KVd7pi2S2";
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
			"dialout"
			"storage"
			"wireshark"
    ];
    packages = [ inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
