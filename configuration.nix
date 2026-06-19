{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/hardware/nvidia.nix
    ./modules/system/bluetooth.nix
    ./modules/system/locale.nix
    ./modules/system/networking.nix
    ./modules/system/pipewire.nix
    ./modules/desktop/plasma.nix
    ./modules/gaming
    ./modules/development
    ./modules/programs/docker.nix
    ./modules/programs/arctis-chatmix.nix
    ./modules/programs/ulauncher.nix
    ./modules/services/printing.nix
    ./modules/services/ssh.nix
    ./modules/services/tailscale.nix
    ./modules/packages/system.nix
    ./modules/packages/user-packages.nix
    ./modules/packages/klassy.nix
    ./modules/packages/odin.nix
    ./modules/users/renskursa.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  console.keyMap = "fi";

  system.stateVersion = "25.05";

  services.upower.enable = true;

  # Power management
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
    };
  };
  services.power-profiles-daemon.enable = false;
  services.thermald.enable = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      max-jobs = "auto";
      cores = 0;
      trusted-users = [ "root" "@wheel" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  security.polkit.enable = true;
  services.fwupd.enable = true;
  hardware.enableRedistributableFirmware = true;
}
