{ config, pkgs, ... }:

{
  # System-wide packages available to all users
  environment.systemPackages = with pkgs; [
    # System Utilities
    vim
    wget
    curl
    tmux
    flatpak
    usbutils
    openvpn
    ktailctl
    bitwarden-desktop
    qbittorrent
    acpi
    
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
    kdePackages.partitionmanager
    wimlib
    xorriso
    syslinux
    rar
    fsearch
    p7zip

    # Container Tools
    docker-compose
    
    # Desktop Applications
    vscode

    # Gaming
    lutris
    (pkgs."moonlight-qt") # Moonlight game streaming client (Qt)
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

}
