{ config, pkgs, ... }:

{
  # Core System Optimisations
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  # Basic Universal Configuration
  time.timeZone = "Australia/Melbourne";
  i18n.defaultLocale = "en_AU.UTF-8";

  # Global packages across all servers and clients
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
    htop
    tmux
  ];

  # Security core
  security.sudo.wheelNeedsPassword = true;
  
  system.stateVersion = "24.11"; # Match target stable/unstable epoch
}

