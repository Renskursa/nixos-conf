{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Utils
    wget
    curl
    flatpak
    usbutils
    openvpn
    ktailctl
    bitwarden-desktop
    qbittorrent
    acpi
    htop
    btop
    neofetch
    fastfetch
    tree
    unzip
    zip
    file
    pciutils
    lsof
    ncdu

    # Disk tools
    kdePackages.partitionmanager
    wimlib
    xorriso
    syslinux
    rar
    fsearch
    p7zip
    gparted
    ventoy

    # Media
    spicetify-cli
    ffmpeg
    mpv
    mpvpaper
    waypaper
    vlc
    yt-dlp
    imagemagick
    gimp
    inkscape

    # Fonts
    fontforge
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    inter
    liberation_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji

    # KDE apps
    kdePackages.kate
    kdePackages.kcalc
    kdePackages.ark
    kdePackages.dolphin
    kdePackages.gwenview
    kdePackages.okular
    kdePackages.spectacle
    kdePackages.konsole
    kdePackages.filelight
  ];

  services.flatpak.enable = true;

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" "Fira Code" ];
      sansSerif = [ "Inter" "Noto Sans" ];
      serif = [ "Noto Serif" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
