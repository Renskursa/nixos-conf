{ config, pkgs, ... }:

{
  # System-wide packages available to all users
  environment.systemPackages = with pkgs; [
    # System Utilities
    vim
    wget
    curl
    flatpak
    usbutils
    openvpn
    ktailctl
    bitwarden
    qbittorrent
    acpi
    rustdesk
    
    # Development Tools
    nodejs_20
    bun
    python3
    git
    ghostty
    
    # Build Tools
    bison
    flex
    fontforge
    makeWrapper
    pkg-config
    gnumake
    gcc
    libiconv
    autoconf
    automake
    libtool
    libopus

    # Disk & Boot Tools
    ventoy-full
    kdePackages.partitionmanager
    wimlib
    xorriso
    syslinux
    rar
    fsearch

    # Container Tools
    docker-compose
    
    # Desktop Applications
    vscode

    # Gaming
    lutris
    protonup-qt
    prismlauncher
    legendary-gl
    rare

    # Media
    spicetify-cli
    ffmpeg
    mpv
    mpvpaper
    waypaper
  ];

  # System-wide configuration
  nixpkgs.config.allowUnfree = true;
  
  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.07"
    "libsoup-2.74.3"
  ];
}
