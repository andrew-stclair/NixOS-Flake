{ config, lib, ... }:

let
  inherit (lib) mkOption types;
  cfg = config.profiles;

  userModulePath = userName: ../../home/users + "/${userName}.nix";

  # Optional display name (GECOS) for known users.
  userDescriptions = {
    andrew = "Andrew St Clair";
    matt = "Matt Vermeer";
  };

  mkUserAccount = userName: {
    name = userName;
    value = {
      isNormalUser = true;
      description = userDescriptions.${userName} or "";
      extraGroups = [ "wheel" "networkmanager" ];
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
