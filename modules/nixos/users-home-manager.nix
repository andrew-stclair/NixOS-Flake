{ userList, ... }:

let
  userModulePath = userName: ../../home/users + "/${userName}.nix";
in
{
  imports = map userModulePath userList;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
