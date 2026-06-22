{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.services.xserver.desktopManager.xfce.enable {
    services.xserver.enable = true;

    services.displayManager.sddm = {
      enable = true;
      theme = "where_is_my_sddm_theme";
    };

    services.xserver.xkb = {
      layout = "fi";
      variant = "winkeys";
    };

    environment.systemPackages = with pkgs; [
      plank
      picom
      xfce.xfce4-whiskermenu-plugin
      xfce.xfce4-pulseaudio-plugin
      xfce.xfce4-clipman-plugin
      xfce.xfce4-weather-plugin
      xfce.xfce4-genmon-plugin

      # Icon theme
      papirus-icon-theme

      # Lock screen
      i3lock-color
      xss-lock            # hooks into XFCE's lock signals
      imagemagick          # for generating blurred lock wallpaper

      # SDDM theme
      where-is-my-sddm-theme
    ];

    # Exclude XFCE bloat we're replacing
    environment.xfce.excludePackages = with pkgs.xfce; [
      xfce4-screensaver    # replaced by i3lock-color
    ];
  };
}
