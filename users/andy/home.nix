{ pkgs, ... }:

{
  home.username = "andy";
  home.homeDirectory = "/home/andy";

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
        name = "Andrew St Clair";
        email = "andrew_stclair95@hotmail.com";
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

  gtk = {
    enable = true;
    theme = {
      name = "Breeze-Dark";
      package = pkgs.breeze-gtk;
    };
    iconTheme = {
      name = "breeze-dark";
      package = pkgs.breeze-icons;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "breeze";
  };

  home.stateVersion = "24.11";
}
