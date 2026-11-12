{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "desktop";

  # Define local user accounts for desktop
  users.users.alice = {
    isNormalUser = true;
    description = "Alice Dev";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  users.users.bob = {
    isNormalUser = true;
    description = "Bob Dev";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  users.users.andy = {
    isNormalUser = true;
    description = "Andy";
    extraGroups = [ "wheel" "networkmanager" ];
  };
}

