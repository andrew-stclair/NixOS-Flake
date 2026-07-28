{ ... }:

{
  programs.home-manager.enable = true;

  programs.git.enable = true;
  programs.zsh.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.stateVersion = "25.05";
}