{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "server";

  # Define local user account for server
  users.users.alice = {
    isNormalUser = true;
    description = "Alice Dev";
    extraGroups = [ "wheel" ];
  };
}

