{ pkgs, ... }:

{
  users.users.matt = {
    isNormalUser = true;
    description = "Matt Vermeer";
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "nixos";
  };

  home-manager.users.matt = {
    imports = [ ../profiles/base.nix ];

    home.username = "matt";
    home.homeDirectory = "/home/matt";

    home.packages = with pkgs; [
      bat
      eza
      fd
      ripgrep
    ];
  };
}
