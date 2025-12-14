{ pkgs, ... }:

{
  home.packages = with pkgs; [
    slack
    zoom-us
    awscli2
    ssm-session-manager-plugin
    aws-vault
    bash
    circleci-cli
  ];
}
