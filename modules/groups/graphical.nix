{ pkgs, ... }:

{
  # Sound & Display Server Essentials
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true; # SDDM display manager for Plasma
  services.displayManager.sddm.theme = "breeze-dark";
  services.desktopManager.plasma6.enable = true; # KDE Plasma 6 environment

  # Configure Plasma6 theme to breeze dark
  programs.plasma.enable = true;
  programs.plasma.configFile = {
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
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Graphical productivity toolkits
  environment.systemPackages = with pkgs; [
    firefox
    alacritty
    vlc
  ];
}

