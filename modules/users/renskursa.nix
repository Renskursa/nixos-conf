
{ config, pkgs, ... }:

{
  users.users.renskursa = {
    isNormalUser = true;
    description = "renskursa";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      kdePackages.kate
      discord-ptb
      google-chrome
      git
      pkgs.freerdp
    ];
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "renskursa";
}

