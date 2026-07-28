{ pkgs, ... }:

{
  imports = [ ../profiles/base.nix ];

  home.username = "matt";
  home.homeDirectory = "/home/matt";

  home.packages = with pkgs; [
    bat
    eza
    fd
    ripgrep
  ];
}
