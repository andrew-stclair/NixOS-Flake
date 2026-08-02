{
  description = "NixOS Flake with shared modules, host profiles, and Home Manager users";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      mkHost = {
        hostName,
        role,
        users ? [ ],
        extraModules ? [ ],
      }:
        lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs self; userList = users; };
          modules = [
            home-manager.nixosModules.home-manager
            ./modules/nixos/common.nix
            ./modules/nixos/users-home-manager.nix
            role
            ({ ... }: {
              networking.hostName = hostName;
            })
            ./hosts/${hostName}
          ] ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        minimal-kde = mkHost {
          hostName = "minimal-kde";
          role = ./modules/nixos/roles/desktop-plasma.nix;
          users = [ "example" "andrew" "matt" ];
        };

        headless-server = mkHost {
          hostName = "headless-server";
          role = ./modules/nixos/roles/headless-server.nix;
          users = [ "example" "andrew" "matt" ];
        };
      };

      checks.${system} = {
        minimal-kde = self.nixosConfigurations.minimal-kde.config.system.build.toplevel;
        headless-server = self.nixosConfigurations.headless-server.config.system.build.toplevel;
      };

      formatter.${system} = pkgs.nixfmt-rfc-style;

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          nil
          nixd
          nixfmt-rfc-style
        ];
      };
    };
}
