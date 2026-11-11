# NixOS Multi-Host Flake Architecture

This repository implements a multi-host, multi-user NixOS configuration using a GitHub repository as the source of truth, backed by automated CI testing via GitHub Actions.

## Directory Layout

```text
.
├── .github/
│   └── workflows/
│       └── nixos-ci.yml            # CI pipeline config
├── flake.nix                       # Central entry point
├── hosts/
│   ├── desktop/
│   │   ├── configuration.nix       # Desktop-specific system config
│   │   └── hardware-configuration.nix
│   └── server/
│       ├── configuration.nix       # Server-specific system config
│       └── hardware-configuration.nix
├── modules/
│   ├── core/                       # Configurations applied to ALL hosts
│   │   └── default.nix
│   └── groups/                     # Shared optional logic
│       ├── graphical.nix
│       └── headless.nix
└── users/
    ├── alice/
    │   └── home.nix                # Alice's Home Manager config
    └── bob/
        └── home.nix                # Bob's Home Manager config
```

## Structure Overview

### 1. Central Flake Registry (`flake.nix`)
Defines the NixOS configurations for all hosts using `nixpkgs` (unstable) and `home-manager`:
- **`desktop`**: Includes core modules, graphical group (KDE Plasma 6 + Ly), and Home Manager users `alice` and `bob`.
- **`server`**: Includes core modules, headless group (OpenSSH hardening, doc stripping), and Home Manager user `alice`.

### 2. Core System Layer (`modules/core/default.nix`)
Universal configuration applied to every host:
- Experimental Nix features (`nix-command`, `flakes`) and automatic store optimisation.
- Timezone (`Australia/Melbourne`) and locale (`en_AU.UTF-8`).
- Global packages: `git`, `vim`, `curl`, `wget`, `htop`, `tmux`.
- Sudo wheel configuration and system state version `24.11`.

### 3. Group Configuration Overlays (`modules/groups/`)
- **`graphical.nix`**: X11/Wayland support, Ly display manager, KDE Plasma 6 desktop environment, PipeWire sound server, and desktop applications (`firefox`, `alacritty`, `vlc`).
- **`headless.nix`**: Hardened OpenSSH daemon (password auth and root login disabled) and stripped documentation.

### 4. User Profiles (`users/`)
Home Manager user configurations managing dotfiles, tools, and user environments:
- **`alice/home.nix`**: Git configuration, bash aliases, and utilities (`ripgrep`, `fd`, `tree`).
- **`bob/home.nix`**: Git configuration, bash aliases, and utilities (`ripgrep`, `fd`, `tree`).

### 5. Host Profiles (`hosts/`)
Each machine has its own directory containing:
- `configuration.nix`: Machine-specific host name, user declarations, bootloader, and role imports.
- `hardware-configuration.nix`: Filesystem declarations and platform settings (can be populated locally via `nixos-generate-config`).

## Usage & Deployment

### 1. Stage Local Changes
Nix flakes only evaluate files tracked by Git:

```bash
git add .
```

### 2. Rebuild / Switch System
Deploy to the local machine directly from the local repository:

```bash
# For a desktop machine
sudo nixos-rebuild switch --flake .#desktop

# For a server machine
sudo nixos-rebuild switch --flake .#server
```

Deploy directly from GitHub:

```bash
sudo nixos-rebuild switch --flake github:andrew-stclair/NixOS-Flake#desktop
sudo nixos-rebuild switch --flake github:andrew-stclair/NixOS-Flake#server
```

### 3. Dry-Run Evaluation / Build
To evaluate derivations without building the full operating system:

```bash
nix eval .#nixosConfigurations.desktop.config.system.build.toplevel.drvPath
nix eval .#nixosConfigurations.server.config.system.build.toplevel.drvPath
```

To build a machine top-level derivation:

```bash
nix build .#nixosConfigurations.desktop.config.system.build.toplevel
```

## Continuous Integration

GitHub Actions (`.github/workflows/nixos-ci.yml`) runs on push and pull requests targeting `main` and `master`:
1. Validates flake structure (`nix flake check`).
2. Evaluates the top-level derivation path for `desktop`.
3. Evaluates the top-level derivation path for `server`.

