{ config, pkgs, ... }:

{
  # System-wide packages available to all users
  environment.systemPackages = with pkgs; [
    # System Utilities
    vim
    wget
    curl
    flatpak
    
    # Development Tools
    nodejs
    bun
    python3
    git
    
    # Disk & Boot Tools
    ventoy-full
    kdePackages.partitionmanager
    wimlib
    xorriso
    syslinux
    
    # Container Tools
    docker-compose
    
    # Desktop Applications
    kdePackages.kate
    vscode
    
    # Gaming
    lutris
    protonup-qt
    prismlauncher
    
    # Media
    spicetify-cli
  ];

  # System-wide configuration
  nixpkgs.config.allowUnfree = true;
  
  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.07"
  ];
}
