
{ config, pkgs, ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 5520 ];
  networking.firewall.allowedUDPPorts = [ 5520 ];
}

