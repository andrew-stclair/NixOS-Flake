#!/usr/bin/env bash
set -euo pipefail

# scripts/test-vm.sh - Boot or build any NixOS system configuration defined in flake.nix inside QEMU.
#
# Usage:
#   ./scripts/test-vm.sh <host> [options]
#   ./scripts/test-vm.sh --list
#   ./scripts/test-vm.sh --help
#
# Note: Uses --impure by default so local hardware configuration
# (/etc/nixos/hardware-configuration.nix) is evaluated if present.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${REPO_DIR}"

IMPURE=true
BUILD_ONLY=false
HEADLESS=false

show_help() {
  cat <<EOF
Usage: $(basename "$0") <host> [options]
       $(basename "$0") --list

Build or boot a full NixOS system configuration defined in flake.nix inside a QEMU Virtual Machine.

Arguments:
  <host>              Name of the NixOS host configuration in nixosConfigurations (e.g., minimal-kde, headless-server)

Options:
  -l, --list          List all available host configurations defined in flake.nix
  -b, --build-only    Build the QEMU VM runner script without launching QEMU
  --headless          Run QEMU in headless/console mode (-nographic)
  --pure              Do not pass --impure flag to nix
  -h, --help          Show this help message

Examples:
  $(basename "$0") minimal-kde
  $(basename "$0") headless-server --headless
  $(basename "$0") minimal-kde --build-only
EOF
}

# Get list of available host configurations from flake.nix
get_hosts() {
  NIX_FLAGS=(--extra-experimental-features "nix-command flakes")
  if [[ "${IMPURE}" == "true" ]]; then
    NIX_FLAGS+=(--impure)
  fi

  if command -v nix >/dev/null 2>&1; then
    if hosts_json=$(nix "${NIX_FLAGS[@]}" eval --json .#nixosConfigurations --apply 'builtins.attrNames' 2>/dev/null); then
      echo "${hosts_json}" | jq -r '.[]' 2>/dev/null && return 0
    fi
  fi

  # Fallback parsing flake.nix if nix evaluation fails or nix is not in PATH
  awk '/nixosConfigurations = \{/,/^[ ]*checks/ { if ($0 ~ /^[ ]{8}[a-zA-Z0-9_-]+ =/) { print $1 } }' flake.nix
}

list_hosts() {
  echo "Available NixOS host configurations in flake.nix:"
  get_hosts | sed 's/^/  - /'
}

TARGET_HOST=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      show_help
      exit 0
      ;;
    -l|--list)
      list_hosts
      exit 0
      ;;
    -b|--build-only)
      BUILD_ONLY=true
      shift
      ;;
    --headless)
      HEADLESS=true
      shift
      ;;
    --pure)
      IMPURE=false
      shift
      ;;
    -*)
      echo "Error: Unknown option '$1'" >&2
      show_help >&2
      exit 1
      ;;
    *)
      if [[ -z "${TARGET_HOST}" ]]; then
        TARGET_HOST="$1"
      else
        echo "Error: Unexpected argument '$1'" >&2
        show_help >&2
        exit 1
      fi
      shift
      ;;
  esac
done

if [[ -z "${TARGET_HOST}" ]]; then
  echo "Error: No NixOS host configuration specified." >&2
  echo "" >&2
  list_hosts >&2
  echo "" >&2
  echo "Run '$(basename "$0") --help' for usage details." >&2
  exit 1
fi

AVAILABLE_HOSTS=$(get_hosts)
if ! echo "${AVAILABLE_HOSTS}" | grep -qx "${TARGET_HOST}"; then
  echo "Error: Host '${TARGET_HOST}' not found in flake.nix nixosConfigurations." >&2
  echo "" >&2
  list_hosts >&2
  exit 1
fi

NIX_IMPURE_FLAG=()
if [[ "${IMPURE}" == "true" ]]; then
  NIX_IMPURE_FLAG=(--impure)
fi

echo "============================================================"
echo " NixOS System Flake QEMU VM Runner"
echo " Host: ${TARGET_HOST}"
echo " Mode: $(if [[ "${BUILD_ONLY}" == "true" ]]; then echo "Build Only"; else echo "Build & Launch"; fi)"
echo " Impure: ${IMPURE}"
echo "============================================================"

# Use nixos-rebuild build-vm if available, otherwise fall back to nix build
if command -v nixos-rebuild >/dev/null 2>&1; then
  echo "Building NixOS VM with nixos-rebuild..."
  nixos-rebuild build-vm --flake ".#${TARGET_HOST}" "${NIX_IMPURE_FLAG[@]}"
else
  echo "Building NixOS VM with nix build..."
  nix build --extra-experimental-features "nix-command flakes" "${NIX_IMPURE_FLAG[@]}" ".#nixosConfigurations.${TARGET_HOST}.config.system.build.vm"
fi

RUNNER=$(find ./result/bin -name "run-*-vm" -o -name "run-nixos-vm" 2>/dev/null | head -n 1)

if [[ -z "${RUNNER}" || ! -x "${RUNNER}" ]]; then
  echo "Error: VM runner script was not found in ./result/bin." >&2
  exit 1
fi

echo "VM runner built: ${RUNNER}"

if [[ "${BUILD_ONLY}" == "true" ]]; then
  echo ""
  echo "To launch the VM manually, run:"
  echo "  ${RUNNER}"
  exit 0
fi

if [[ "${HEADLESS}" == "true" ]]; then
  export QEMU_OPTS="${QEMU_OPTS:-} -nographic"
fi

echo "Starting NixOS VM for '${TARGET_HOST}'..."
echo "(Press Ctrl+A then X to exit QEMU if running headless)"
echo ""

exec "${RUNNER}"
