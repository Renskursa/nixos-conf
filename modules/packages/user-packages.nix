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
    (ungoogled-chromium.override {
      commandLineArgs = "--enable-blink-features=MiddleClickAutoscroll";
    })

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
    jellyfin-media-player

    # Screenshot
    flameshot
    peek

    # System
    baobab
    gnome-system-monitor
  ];
}
