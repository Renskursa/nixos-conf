{ config, pkgs, ... }:

{
  users.users.renskursa = {
    isNormalUser = true;
    description = "renskursa";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "renskursa";
}
