{ config, pkgs, inputs, ... }:

{
  # Packages from flake inputs
  # This module expects 'inputs' to be passed from flake.nix
  environment.systemPackages = [
  pkgs.winboat
    
    # Better Blur - using v1.3.6 compatible with Plasma 6.0.0 - 6.3.5
    # Choose the appropriate one for your session:
    inputs.kwin-effects-forceblur.packages.${pkgs.stdenv.hostPlatform.system}.default  # Wayland (Plasma 6 default)
    inputs.cursor-nixos-flake.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
