{ lib, userList ? [ ], ... }:

let
  userModulePath = userName: ../../home/users + "/${userName}.nix";
  existingUsers = lib.filter (u: builtins.pathExists (userModulePath u)) userList;
  missingUsers = lib.filter (u: !(builtins.pathExists (userModulePath u))) userList;
in
{
  imports = map userModulePath existingUsers;

  assertions = map (userName: {
    assertion = false;
    message = "User module file not found for '${userName}': expected at ${toString (userModulePath userName)}";
  }) missingUsers;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
