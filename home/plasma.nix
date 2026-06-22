{ osConfig, lib, pkgs, ... }:

# Declarative KDE Plasma config via plasma-manager.
# Snapshotted from the live setup with rc2nix, then curated.
#
# overrideConfig is left at its default (false): only the keys defined
# here are managed, so anything you change in the GUI that isn't listed
# below still persists. Re-run `nix run github:nix-community/plasma-manager`
# to capture new tweaks.

lib.mkIf osConfig.services.desktopManager.plasma6.enable {
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

  programs.plasma = {
    enable = true;

    #
    # Custom global shortcuts (the meaningful ones; defaults omitted)
    #
    shortcuts = {
      # Window management / overview / tiling
      kwin.Overview = "Meta+W";
      kwin."Edit Tiles" = "Meta+T";
      kwin."Grid View" = "Meta+G";
      kwin."Show Desktop" = "Meta+D";
      kwin."Window Maximize" = "Meta+PgUp";
      kwin."Window Minimize" = "Meta+PgDown";
      kwin."Window Quick Tile Left" = "Meta+Left";
      kwin."Window Quick Tile Right" = "Meta+Right";
      kwin."Window Quick Tile Top" = "Meta+Up";
      kwin."Window Quick Tile Bottom" = "Meta+Down";

      # Clipboard history popup at cursor
      plasmashell.show-on-mouse-pos = "Meta+V";
      plasmashell.clipboard_action = "Meta+Ctrl+X";

      # App launcher (KRunner / menu)
      plasmashell."activate application launcher" = [ "Meta" "Alt+F1" ];

      # ULauncher toggle — primary launcher (Spotlight-style Meta+Space, plus Alt+§)
      "services/net.local.ulauncher-toggle.desktop"._launch = [ "Meta+Space" "Alt+§" ];

      # Power profile toggle
      org_kde_powerdevil.powerProfile = [ "Battery" "Meta+B" ];
    };

    configFile = {
      #
      # Window decoration — Klassy with the Win11-style button layout.
      # Left:  Menu, Keep-Above, On-All-Desktops   (MFS)
      # Right: Help, Minimize, Maximize, Close      (HIAX)
      #
      kwinrc."org.kde.kdecoration2".theme = "Klassy";
      kwinrc."org.kde.kdecoration2".ButtonsOnLeft = "MFS";
      kwinrc."org.kde.kdecoration2".ButtonsOnRight = "HIAX";
      kwinrc."org.kde.kdecoration2".BorderSize = "Normal";
      kwinrc."org.kde.kdecoration2".BorderSizeAuto = false;

      #
      # Desktop effects — blur + background contrast on, shake-cursor off
      #
      kwinrc.Plugins.blurEnabled = true;
      kwinrc.Plugins.contrastEnabled = false;
      kwinrc.Plugins.shakecursorEnabled = false;

      # KWin Blur strength (ranges from 1 to 15)
      kwinrc."Effect-blur".BlurStrength = 4;

      # Yakuake settings
      "yakuakerc"."Appearance"."Translucency" = true;
      "yakuakerc"."Appearance"."Blur" = true;

      # Translucency for menus / dialogs (subtle polish)
      kwinrc.Effect-translucency.Dialogs = 64;
      kwinrc.Effect-translucency.Menus = 52;
      kwinrc.Effect-translucency.PopupMenus = 70;
      kwinrc.Effect-translucency.DropdownMenus = 52;
      kwinrc.Effect-translucency.MoveResize = 71;
      kwinrc.Effect-translucency.IndividualMenuConfig = true;

      # Overview: trigger by pushing the cursor into the top-left corner
      kwinrc.Effect-overview.BorderActivate = 7;

      #
      # Input — touchpad
      #
      kcminputrc."Libinput/1267/12410/ELAN1203:00 04F3:307A Touchpad".NaturalScroll = true;
      kcminputrc."Libinput/1267/12410/ELAN1203:00 04F3:307A Touchpad".DisableWhileTyping = true;
      kcminputrc."Libinput/1267/12410/ELAN1203:00 04F3:307A Touchpad".ScrollFactor = 0.3;
      kcminputrc."Libinput/1267/12410/ELAN1203:00 04F3:307A Touchpad".DisableEventsOnExternalMouse = false;

      # Input — Logitech G703 mouse pointer acceleration
      kcminputrc."Libinput/1133/16518/Logitech G703 LS".PointerAcceleration = "-0.400";
      kcminputrc."Libinput/1133/16518/Logitech G703 LS".PointerAccelerationProfile = 1;

      # Disable DualSense controller touchpad as a pointer
      kcminputrc."Libinput/1356/3302/DualSense Wireless Controller Touchpad".Enabled = false;

      #
      # KRunner — enable the genuinely useful runners.
      # Type into KRunner (Meta) or on the desktop to use them:
      #   "5*1024"          -> calculator
      #   "100 usd in eur"  -> unit/currency converter
      #   "gg: nixos wiki"  -> web shortcut (Google), "wiki:", "yt:", etc.
      #   "define serene"   -> dictionary
      #
      krunnerrc.Plugins.calculatorEnabled = true;
      krunnerrc.Plugins.unitconverterEnabled = true;
      krunnerrc.Plugins."krunner_dictionaryEnabled" = true;
      krunnerrc.Plugins."krunner_spellcheckEnabled" = true;
      krunnerrc.Plugins."krunner_webshortcutsEnabled" = true;
      krunnerrc.Plugins."krunner_shellEnabled" = true;          # run commands
      krunnerrc.Plugins."krunner_killEnabled" = true;           # "kill firefox"
      krunnerrc.General.FreeFloating = true;                    # centered, not docked to top

      #
      # Night Color — warm the screen in the evening (auto by location)
      #
      kwinrc.NightColor.Active = true;
      kwinrc.NightColor.Mode = "Location";
      kwinrc.NightColor.NightTemperature = 4500;

      #
      # Clipboard (Klipper) — bigger persistent history
      #
      klipperrc.General.KeepClipboardContents = true;
      klipperrc.General.MaxClipItems = 50;
      klipperrc.General.PreventEmptyClipboard = true;

      #
      # Misc quality-of-life
      #
      plasmaparc.General.RaiseMaximumVolume = true;            # allow >100% volume
      kded5rc.Module-device_automounter.autoload = false;      # no auto-mount popups
      kded5rc.Module-browserintegrationreminder.autoload = false;
    };
  };
}
