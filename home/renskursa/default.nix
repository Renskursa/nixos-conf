{ pkgs, ... }:

{
  imports = [
    ./plasma.nix
    ./ulauncher.nix
  ];

  home.username = "renskursa";
  home.homeDirectory = "/home/renskursa";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  # Yakuake — Quake-style drop-down terminal (toggle with F12)
  home.packages = [ pkgs.kdePackages.yakuake ];
  xdg.configFile."autostart/org.kde.yakuake.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Yakuake
    Exec=yakuake
    X-KDE-autostart-phase=2
  '';

  # Stylix targets — per-app theming
  stylix.targets.kde.enable = false;
  stylix.targets.ghostty.enable = true;
  stylix.targets.bat.enable = true;
  stylix.targets.btop.enable = true;
  stylix.targets.fzf.enable = true;
  stylix.targets.starship.enable = true;
  stylix.targets.tmux.enable = true;
  stylix.targets.zed.enable = true;
  stylix.targets.helix.enable = true;

  # Let starship be managed by HM so Stylix can write its theme
  programs.starship.enable = true;

  # Let btop be managed by HM so Stylix can write its theme
  programs.btop.enable = true;

  # Let bat be managed by HM so Stylix can write its theme
  programs.bat.enable = true;
}
