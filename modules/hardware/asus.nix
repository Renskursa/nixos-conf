{ pkgs, ... }:

{
  services.asusd.enable = true;

  services.supergfxd.enable = true;

  environment.systemPackages = with pkgs; [
    asusctl
    supergfxctl
  ];
}
