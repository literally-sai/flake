{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "literally-sai";
        email = "sai@literally-sai.com";
      };

      init = {
        defaultBranch = "main";
      };

      push = {
        autoSetupRemote = true;
      };
    };
  };
}
