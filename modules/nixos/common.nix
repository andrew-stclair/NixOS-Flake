{ lib, pkgs, ... }:

let
  localHardwareModule = "/etc/nixos/hardware-configuration.nix";
in
{
  warnings = lib.optional (!(builtins.pathExists localHardwareModule)) ''
    Local hardware config was not imported: ${localHardwareModule}

    On a real machine, generate it and rebuild with --impure:
      sudo nixos-generate-config --show-hardware-config > ${localHardwareModule}
      sudo nixos-rebuild switch --flake .#<host> --impure
  '';

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # Fallback root filesystem keeps CI evaluation/builds working when local
  # hardware-configuration.nix files are intentionally excluded from git.
  fileSystems."/" = lib.mkDefault {
    device = "none";
    fsType = "tmpfs";
    options = [ "mode=755" ];
  };

  networking.networkmanager.enable = lib.mkDefault true;

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  services.openssh.enable = lib.mkDefault true;

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    curl
    git
    htop
    tree
    vim
    wget
  ];

  system.stateVersion = "25.05";
}