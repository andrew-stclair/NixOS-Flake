{ config, lib, ... }:

let
  inherit (lib) mkOption types;
  cfg = config.profiles;

  userModulePath = userName: ../../home/users + "/${userName}.nix";

  mkUserAccount = userName: {
    name = userName;
    value = {
      isNormalUser = true;
      extraGroups = [ "wheel", "networkmanager" ];
      initialPassword = "nixos";
    };
  };

  mkHomeManagerUser = userName: {
    name = userName;
    value = import (userModulePath userName);
  };
in
{
  options.profiles.users = mkOption {
    type = types.listOf types.str;
    default = [ ];
    description = "User module names from home/users/*.nix to enable on this host.";
  };

  config = {
    assertions = map
      (userName: {
        assertion = builtins.pathExists (userModulePath userName);
        message = "Missing Home Manager user module: home/users/${userName}.nix";
      })
      cfg.users;

    users.users = builtins.listToAttrs (map mkUserAccount cfg.users);

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users = builtins.listToAttrs (map mkHomeManagerUser cfg.users);
    };
  };
}
