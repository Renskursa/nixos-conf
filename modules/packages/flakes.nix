{ config, pkgs, inputs, ... }:

{
  # Packages from flake inputs
  # This module expects 'inputs' to be passed from flake.nix
  environment.systemPackages = [
    inputs.winboat.packages.x86_64-linux.winboat
    inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
  ];
}
