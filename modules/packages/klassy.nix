{ config, pkgs, lib, inputs, ... }:

let
  klassy = pkgs.stdenv.mkDerivation rec {
    pname = "klassy";
    version = "latest";

    src = inputs.klassy-src;

    nativeBuildInputs = with pkgs; [
      cmake
      kdePackages.extra-cmake-modules
      kdePackages.wrapQtAppsHook
      pkg-config
      gettext
    ];

    buildInputs = with pkgs.kdePackages; [
      frameworkintegration
      kcmutils
      kcolorscheme
      kconfig
      kconfigwidgets
      kcoreaddons
      kguiaddons
      ki18n
      kiconthemes
      kirigami
      kpackage
      kservice
      kwindowsystem
      kdecoration
      plasma-workspace
      pkgs.qt6.qtbase
      pkgs.qt6.qtdeclarative
      pkgs.qt6.qtsvg
      pkgs.libx11
    ];

    cmakeFlags = [
      "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
      "-DBUILD_QT5=OFF"
      "-DBUILD_QT6=ON"
    ];

    meta = with pkgs.lib; {
      description = "Highly customizable binary Window Decoration and Application Style plugin for KDE Plasma";
      homepage = "https://github.com/paulmcauley/klassy";
      license = licenses.gpl2Plus;
      platforms = platforms.linux;
    };
  };
in
{
  config = lib.mkIf config.services.desktopManager.plasma6.enable {
    environment.systemPackages = [ klassy ];
  };
}
