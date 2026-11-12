# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.hostName = "test-vm"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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

  users.users."andy" = {
    isNormalUser = true;
    description = "Andrew St Clair";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}