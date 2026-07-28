{ lib, ... }:

let
  localHardwareModule = "/etc/nixos/hardware-configuration.nix";
in
{
  imports = lib.optional (builtins.pathExists localHardwareModule) localHardwareModule;

  networking.hostId = "a1b2c3d4";

  services.xserver.xkb.layout = "us";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}