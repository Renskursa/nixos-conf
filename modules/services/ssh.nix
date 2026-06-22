{ config, pkgs, ... }:

{
  # Enable the OpenSSH daemon
  services.openssh = {
    enable = true;
    
    settings = {
      # Security settings
      PermitRootLogin = "no";
      PasswordAuthentication = false;  # Key-based auth only
    };
    
    # Open firewall ports automatically
    openFirewall = true;
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
  };
}
