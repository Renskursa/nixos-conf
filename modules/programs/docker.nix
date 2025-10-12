
{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  virtualisation.docker.package = pkgs.docker_28;
}

