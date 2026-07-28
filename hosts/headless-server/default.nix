{ lib, ... }:

let
  localHardwareModule = "/etc/nixos/hardware-configuration.nix";
in
{
  imports = lib.optional (builtins.pathExists localHardwareModule) localHardwareModule;

  networking.hostId = "d4c3b2a1";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };
}