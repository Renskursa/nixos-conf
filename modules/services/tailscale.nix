{ config, pkgs, ... }:

{
  # Enable Tailscale VPN service
  services.tailscale.enable = true;

  # Optional: Enable Tailscale in the firewall
  # This allows Tailscale to manage its own firewall rules
  networking.firewall = {
    # Allow Tailscale traffic
    trustedInterfaces = [ "tailscale0" ];
    
    # Allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  # Optional: Add Tailscale to system packages for CLI access
  environment.systemPackages = with pkgs; [
    tailscale
  ];
}
