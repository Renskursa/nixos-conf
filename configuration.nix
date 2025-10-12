# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ 
      # Hardware
      ./hardware-configuration.nix
      
      # System Configuration
      ./modules/system/bluetooth.nix
      ./modules/system/locale.nix
      ./modules/system/networking.nix
      ./modules/system/pipewire.nix
      
      # Desktop Environment
      ./modules/desktop/plasma.nix
      
      # Programs & Services
      ./modules/programs/steam.nix
      ./modules/programs/docker.nix
      ./modules/services/printing.nix
      
      # Package Lists
      ./modules/packages/system.nix
      ./modules/packages/user-packages.nix
      
      # Users
      ./modules/users/renskursa.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Console keymap
  console.keyMap = "fi";

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
