{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Utils
    tgpt
    wget
    curl

    usbutils
    openvpn
    bitwarden-desktop
    qbittorrent
    acpi
    htop
    fastfetch
    tree
    unzip
    zip
    file
    pciutils
    lsof
    ncdu

    # Disk tools
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
    yt-dlp

    gimp
    inkscape

    # Fonts (base set — JetBrains Mono, Inter, Noto, Noto Emoji are in stylix.nix)
    fontforge
    nerd-fonts.fira-code
    nerd-fonts.hack
    liberation_ttf
    noto-fonts-cjk-sans

    # File manager
    nautilus
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

  environment.shellAliases = {
    ask = "tgpt -s";
  };
}
