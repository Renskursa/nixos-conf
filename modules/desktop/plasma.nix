{ config, pkgs, lib, ... }:

{
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = lib.mkForce true;
  };

  # Note: this Stylix version has no `sddm` target, so the SDDM login screen
  # is not themed by Stylix. The Plasma desktop and lock screen are still
  # themed via the `kde` target. See modules/desktop/stylix.nix.

  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "fi";
    variant = "winkeys";
  };

  services.hardware.openrgb = {
    enable = true;
    motherboard = "intel";
  };

  environment.systemPackages = with pkgs; [
    kdePackages.kde-cli-tools
    kdePackages.plasma-browser-integration
    kdePackages.plasma-vault
    kdePackages.plasma-disks
    kdePackages.kdeconnect-kde
    kdePackages.sddm-kcm
    kdePackages.kio-extras
    kdePackages.kio-fuse
    kdePackages.ffmpegthumbs
    kdePackages.kdegraphics-thumbnailers
    kdePackages.kwayland
    kdePackages.kwayland-integration
    kdePackages.krdc
    kdePackages.kdialog
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  };

  services.dbus.packages = [ pkgs.kdePackages.kdeconnect-kde ];

  # KDE Connect ports
  networking.firewall = {
    allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
    allowedUDPPortRanges = [{ from = 1714; to = 1764; }];
  };
}
