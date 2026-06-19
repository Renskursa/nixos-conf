{ config, pkgs, ... }:

{
  users.users.renskursa.packages = with pkgs; [
    # Communication
    discord-ptb
    slack
    telegram-desktop
    signal-desktop
    element-desktop

    # Browsers
    google-chrome
    firefox
    brave

    # Remote/sharing
    freerdp
    localsend
    remmina
    filezilla
    syncthing

    # Productivity
    obsidian
    notion-app-enhanced
    libreoffice
    thunderbird
    todoist-electron

    # Media
    spotify
    stremio
    plex-media-player

    # Screenshot
    flameshot
    peek

    # System
    baobab
    gnome-system-monitor
  ];
}
