# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # ...
  };
  outputs = { self, nixpkgs, home-manager }:
    let 
      # ...
    in {
      # ...
      nixosConfigurations = {
        nixos = {
          system = "x86_64-linux";
          modules = with self.nixosModules; [
            ({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; })
            # ...
            home-manager.nixosModules.home-manager
            gnome
            declarativeHome
            users-andrew
          ];
        };
        # ...
      }
      nixosModules = {
        # ...
        declarativeHome = { ... }: {
          config = {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          };
        };
        users-andrew = ./users/andrew;
      };
    };
  # ...
}
