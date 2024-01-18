# users/andrew/default.nix
{ ... }:

{
  config = {
    home-manager.users.andrew = ./home.nix;
    users.users.andrew = {
      # ...
    };
  };
}
