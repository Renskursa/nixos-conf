{ config, pkgs, ... }:

{
  # Enable the OpenSSH daemon
  services.openssh = {
    enable = true;
    
    settings = {
      # Security settings
      PermitRootLogin = "no";
      PasswordAuthentication = true;  # Set to false if you only want key-based auth
    };
    
    # Open firewall ports automatically
    openFirewall = true;
  };
}
