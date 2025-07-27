{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos.nix
          ./modules/base.nix
          ./modules/gnome.nix
          ./modules/latest-kernel.nix
          home-manager.nixosModules.home-manager
        ];
        specialArgs = { inherit self; };
      };
      nixos-flake = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-flake.nix
          ./modules/base.nix
          ./modules/plasma.nix
          ./modules/latest-kernel.nix
          home-manager.nixosModules.home-manager
        ];
        specialArgs = { inherit self; };
      };
    };

    # homeConfigurations = {
    #   andrew = home-manager.lib.homeManagerConfiguration {
    #     pkgs = nixpkgs.legacyPackages.x86_64-linux;
    #     modules = [ ./home.nix ];
    #   };
    # };
  };
}
