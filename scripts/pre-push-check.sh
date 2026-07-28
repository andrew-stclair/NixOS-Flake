#!/usr/bin/env bash
set -euo pipefail

echo "Running flake checks (eval + build graph)..."
nix --extra-experimental-features "nix-command flakes" flake check

echo "Evaluating host system derivations..."
nix --extra-experimental-features "nix-command flakes" eval .#nixosConfigurations.minimal-kde.config.system.build.toplevel.drvPath >/dev/null
nix --extra-experimental-features "nix-command flakes" eval .#nixosConfigurations.headless-server.config.system.build.toplevel.drvPath >/dev/null

echo "Evaluating user activation package..."
nix --extra-experimental-features "nix-command flakes" eval .#homeConfigurations.example@minimal-kde.activationPackage.drvPath >/dev/null

echo "All pre-push checks passed."