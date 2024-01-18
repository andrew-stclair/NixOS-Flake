 users/andrew/home.nix
{ ... }:

{
  home.username = "andrew";
  home.homeDirectory = "/home/andrew";
  # ...
  programs.home-manager.enable = true;
  home.stateVersion = "22.05";
}