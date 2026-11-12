{ pkgs, ... }:

{
  # Sound & Display Server Essentials
  services.xserver.enable = true;
  services.displayManager.ly.enable = true; # Lightweight display manager
  services.desktopManager.plasma6.enable = true; # KDE Plasma 6 environment

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

