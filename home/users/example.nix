{ pkgs, ... }:

{
  users.users.example = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "nixos";
  };

  home-manager.users.example = {
    imports = [ ../profiles/base.nix ];

    home.username = "example";
    home.homeDirectory = "/home/example";

    home.packages = with pkgs; [
      bat
      eza
      fd
      ripgrep
    ];
  };
}