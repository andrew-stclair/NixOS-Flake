{ pkgs, ... }:

{
  users.users.andrew = {
    isNormalUser = true;
    description = "Andrew St Clair";
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "nixos";
  };

  home-manager.users.andrew = {
    imports = [ ../profiles/base.nix ];

    home.username = "andrew";
    home.homeDirectory = "/home/andrew";

    home.packages = with pkgs; [
      bat
      eza
      fd
      ripgrep
    ];
  };
}
