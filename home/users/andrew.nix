{ pkgs, ... }:

{
  imports = [ ../profiles/base.nix ];

  home.username = "andrew";
  home.homeDirectory = "/home/andrew";

  home.packages = with pkgs; [
    bat
    eza
    fd
    ripgrep
  ];
}
