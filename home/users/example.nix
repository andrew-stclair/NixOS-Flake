{ pkgs, ... }:

{
  imports = [ ../profiles/base.nix ];

  home.username = "example";
  home.homeDirectory = "/home/example";

  home.packages = with pkgs; [
    bat
    eza
    fd
    ripgrep
  ];
}