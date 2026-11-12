{ config, pkgs, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Core System Optimisations
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Global packages across all servers and clients
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
    htop
    tmux
    (writeShellScriptBin "nixos-update" ''
      # System-wide NixOS update script
      # Updates the system, cleans up old generations, and removes unused store files

      set -euo pipefail

      # Get the hostname
      HOSTNAME=$(hostname)

      echo "🔄 Updating NixOS system (''${HOSTNAME})..."
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

      # Run nixos-rebuild with the hostname-specific flake configuration
      sudo nixos-rebuild switch \
        --flake "github:andrew-stclair/NixOS-Flake#''${HOSTNAME}" \
        --refresh

      echo ""
      echo "✅ System update completed!"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo ""

      # Remove old generations, keeping only the 3 most recent
      echo "🧹 Cleaning up old generations (keeping 3 most recent)..."
      sudo nix-env --profile /nix/var/nix/profiles/system \
        --delete-generations +3

      echo ""
      echo "🗑️  Removing unused store files..."
      sudo nix store gc

      echo ""
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "✨ System update and cleanup complete!"
    '')
  ];

  # Security core
  security.sudo.wheelNeedsPassword = true;
  
  system.stateVersion = "26.05";
}

