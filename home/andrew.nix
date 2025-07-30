{ config, pkgs, ... }:

{
  home.username = "andrew";
  home.homeDirectory = "/home/andrew";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Example: Enable some basic programs
  programs.zsh.enable = true;
  programs.git.enable = true;

  # Example: Set some environment variables
  home.sessionVariables = {
    EDITOR = "nano";
  };

  # Example: Add some packages
  home.packages = [
    pkgs.vim
    pkgs.htop
    pkgs.curl
    pkgs.nano
  ];

  # You can add more customizations below
}
