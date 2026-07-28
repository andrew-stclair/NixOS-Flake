# NixOS Flake

This repository is structured for multi-machine NixOS management with:

- Shared system defaults in one central place
- Host-specific machine configuration per host
- Home Manager user profiles per user
- Host-to-user wiring so a host can enable one or many users
- CI and automated lockfile updates
- Local-only hardware configuration support

## Layout

```text
.
├── flake.nix
├── modules/
│   └── nixos/
│       ├── common.nix
│       ├── users-home-manager.nix
│       └── roles/
│           ├── desktop-plasma.nix
│           └── headless-server.nix
├── hosts/
│   ├── minimal-kde/default.nix
│   └── headless-server/default.nix
├── home/
│   ├── profiles/base.nix
│   └── users/example.nix
└── scripts/pre-push-check.sh
```

## Hardware Configuration Stays Local

Each host imports `/etc/nixos/hardware-configuration.nix` from the local machine.

This means hardware config does not live in this repository.

Generate or refresh it locally on each host:

```bash
sudo nixos-generate-config --show-hardware-config > /etc/nixos/hardware-configuration.nix
```

Important: when rebuilding from this flake, use `--impure` so Nix can read local `/etc` content.

If `/etc/nixos/hardware-configuration.nix` is missing (or not importable in a pure eval),
the shared module emits a warning during evaluation with the fix command.

## Central + Host + User Model

- Shared configuration for all machines: `modules/nixos/common.nix`
- Host role configuration: `modules/nixos/roles/*.nix`
- Host overrides and machine specifics: `hosts/<host>/default.nix`
- User profiles (Home Manager): `home/users/*.nix`

Host-to-user mapping is done in `flake.nix` with the `users = [ ... ]` list per host.

## Example Machines

- Minimal KDE Plasma desktop: `minimal-kde`
- Headless server: `headless-server`

They are defined in `flake.nix` and implemented in `hosts/` + `modules/nixos/roles/`.

## Example User

`home/users/example.nix` imports `home/profiles/base.nix` and provides user-level packages and settings.

## Usage

Switch the local machine to one of the example host configs:

```bash
sudo nixos-rebuild switch --flake .#minimal-kde --impure
```

or

```bash
sudo nixos-rebuild switch --flake .#headless-server --impure
```

Build without switching:

```bash
nix --extra-experimental-features "nix-command flakes" build .#nixosConfigurations.minimal-kde.config.system.build.toplevel
nix --extra-experimental-features "nix-command flakes" build .#nixosConfigurations.headless-server.config.system.build.toplevel
```

## Local Validation Before Pushing

Run:

```bash
bash scripts/pre-push-check.sh
```

This runs:

- `nix flake check`
- Host derivation evaluation
- Home Manager derivation evaluation

## GitHub Automation

- CI workflow: `.github/workflows/ci.yml`
	- Runs on push/PR
	- Executes `nix flake check`
	- Evaluates host and Home Manager derivations

- Lock update workflow: `.github/workflows/update-flake-lock.yml`
	- Scheduled weekly and manually dispatchable
	- Runs `nix flake update`
	- Validates with `nix flake check`
	- Opens a pull request with updated `flake.lock`
