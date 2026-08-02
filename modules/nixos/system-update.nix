{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "system-update" ''
      set -euo pipefail

      if [ "$(id -u)" -ne 0 ]; then
        echo "Error: This script must be run as root (e.g., via sudo)." >&2
        exit 1
      fi

      FLAKE_DIR="/etc/nixos"
      HOST="$(hostname)"

      if [ ! -d "$FLAKE_DIR/.git" ]; then
        echo "Error: $FLAKE_DIR is not a git repository." >&2
        exit 1
      fi

      echo "Pulling latest changes in $FLAKE_DIR (fast-forward only)..."
      cd "$FLAKE_DIR"
      git pull --ff-only

      echo "Rebuilding and switching to flake configuration for host: $HOST"
      nixos-rebuild switch --flake ".#$HOST"

      echo "System update complete."
    '')
  ];
}
