{ pkgs, ... }:

{
  services.xserver.enable = false;

  networking.networkmanager.enable = false;
  networking.useNetworkd = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.fail2ban.enable = true;

  environment.systemPackages = with pkgs; [
    dig
    jq
    tmux
  ];
}