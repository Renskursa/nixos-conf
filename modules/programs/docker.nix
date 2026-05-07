
{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
  
  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker.package = pkgs.docker_28;
}

