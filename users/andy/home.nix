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
      package = null;
    };
    iconTheme = {
      name = "breeze-dark";
      package = null;
    };
  };

  programs.plasma = {
    enable = true;
    configFile = {
      "kdeglobals" = {
        "General" = {
          "ColorScheme" = "BreezeDark";
        };
      };
      "plasmarc" = {
        "Theme" = {
          "name" = "breeze-dark";
        };
      };
      "kscreenlockerrc" = {
        "Greeter" = {
          "Theme" = "org.kde.breezedark.desktop";
        };
      };
    };
  };

  home.activation = {
    removeConflictingFiles = ''
      rm -f $HOME/.gtkrc-2.0
      rm -f $HOME/.config/gtk-3.0/settings.ini
      rm -f $HOME/.config/gtk-4.0/settings.ini
      rm -f $HOME/.config/Trolltech.conf
    '';
  };

  home.stateVersion = "26.05";
}
