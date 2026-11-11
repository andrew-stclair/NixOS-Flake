{ ... }:

{
  # Optimise performance profiles for headless machines
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Disable unwanted graphical management stacks
  documentation.doc.enable = false;
  documentation.man.enable = true;
}
