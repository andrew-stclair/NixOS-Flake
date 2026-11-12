{
  description = "Production multi-host, multi-user NixOS infrastructure";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: {
    nixosConfigurations = {
      
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop/configuration.nix
          ./modules/core/default.nix
          ./modules/groups/graphical.nix
          
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.backupCommand = "rm";
            home-manager.users.alice = import ./users/alice/home.nix;
            home-manager.users.bob = import ./users/bob/home.nix;
          }
        ];
      };

      server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/server/configuration.nix
          ./modules/core/default.nix
          ./modules/groups/headless.nix
          
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.backupCommand = "rm";
            home-manager.users.alice = import ./users/alice/home.nix;
          }
        ];
      };

      test-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/test-vm/configuration.nix
          ./modules/core/default.nix
          ./modules/groups/graphical.nix
          
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.backupCommand = "rm";
            home-manager.users.alice = import ./users/alice/home.nix;
            home-manager.users.bob = import ./users/bob/home.nix;
            home-manager.users.andy = import ./users/andy/home.nix;
          }
        ];
      };
      
    };
  };
}

