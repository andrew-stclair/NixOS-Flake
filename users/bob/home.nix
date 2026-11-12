{ pkgs, ... }:

{
  home.username = "bob";
  home.homeDirectory = "/home/bob";

  # Shell customisation & packages managed by Home Manager
  home.packages = with pkgs; [
    ripgrep
    fd
    tree
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Bob Dev";
        email = "bob@example.internal";
      };
      init.defaultBranch = "main";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      g = "git";
    };
  };

  home.stateVersion = "26.05";
}
