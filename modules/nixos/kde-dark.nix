{ ... }:

{
  # Apply Breeze Dark as the system-wide default color scheme.
  # This sets defaults for new user sessions via XDG configuration.
  environment.etc."xdg/kdeglobals".text = ''
    [General]
    ColorScheme=BreezeDark
    Name=Breeze Dark

    [KDE]
    LookAndFeelPackage=org.kde.breezedark.desktop
  '';

  # Set SDDM (login screen) to use the Breeze Dark theme.
  services.displayManager.sddm.theme = "breeze";
}
