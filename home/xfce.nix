{ config, osConfig, lib, pkgs, ... }:

lib.mkIf osConfig.services.xserver.desktopManager.xfce.enable {

  # ───────────────────────────────────────────────────────────────
  # Picom — smooth compositing with rounded corners and blur
  # ───────────────────────────────────────────────────────────────
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;

    fade = true;
    fadeDelta = 5;
    fadeSteps = [ 0.03 0.03 ];

    shadow = true;
    shadowOffsets = [ (-12) (-12) ];
    shadowOpacity = 0.45;
    shadowExclude = [
      "class_g = 'Plank'"
      "class_g = 'xfce4-screenshooter'"
      "_GTK_FRAME_EXTENTS@:c"
    ];

    inactiveOpacity = 0.92;
    activeOpacity = 1.0;
    menuOpacity = 0.95;
    opacityRules = [
      "100:class_g = 'mpv'"
      "100:class_g = 'firefox'"
      "100:class_g = 'Google-chrome'"
      "100:class_g = 'Gimp'"
      "95:class_g = 'Thunar'"
      "90:class_g = 'xfce4-panel'"
    ];

    settings = {
      corner-radius = 10;
      rounded-corners-exclude = [
        "class_g = 'xfce4-panel'"
        "class_g = 'Plank'"
        "window_type = 'dock'"
        "window_type = 'desktop'"
      ];

      blur-method = "dual_kawase";
      blur-strength = 4;
      blur-background = true;
      blur-background-frame = false;
      blur-background-fixed = false;
      blur-background-exclude = [
        "class_g = 'Plank'"
        "window_type = 'dock'"
        "window_type = 'desktop'"
        "_GTK_FRAME_EXTENTS@:c"
      ];

      # Animations
      transition-length = 200;
      transition-pow-x = 0.2;
      transition-pow-y = 0.2;
      transition-pow-w = 0.2;
      transition-pow-h = 0.2;
      size-transition = true;

      # Performance
      glx-no-stencil = true;
      glx-no-rebind-pixmap = true;
      use-damage = true;
      xrender-sync-fence = true;
      detect-transient = true;
      detect-client-leader = true;

      # Dim inactive windows slightly
      inactive-dim = 0.05;

      # Window type specific rules
      wintypes = {
        tooltip = { fade = true; shadow = false; opacity = 0.9; };
        menu = { fade = true; shadow = true; opacity = 0.95; };
        popup_menu = { fade = true; shadow = true; opacity = 0.95; };
        dropdown_menu = { fade = true; shadow = true; opacity = 0.95; };
        dock = { shadow = false; };
        dnd = { shadow = false; };
      };
    };
  };

  # ───────────────────────────────────────────────────────────────
  # Plank — modern dock at the bottom
  # ───────────────────────────────────────────────────────────────
  xdg.configFile."autostart/plank.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Plank
    Exec=plank
    X-GNOME-Autostart-enabled=true
  '';

  # ───────────────────────────────────────────────────────────────
  # Lock screen — beautiful blurred wallpaper lock via i3lock-color
  # ───────────────────────────────────────────────────────────────

  # Script that takes a screenshot, blurs it, and locks with i3lock-color
  home.file.".local/bin/lock.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Tokyo Night palette
      BG="1a1b26"
      FG="c0caf5"
      ACCENT="7aa2f7"
      RED="f7768e"
      GREEN="9ece6a"
      RING="414868"

      # Take screenshot & blur it
      TMPIMG="/tmp/lockscreen.png"
      ${pkgs.imagemagick}/bin/import -window root "$TMPIMG"
      ${pkgs.imagemagick}/bin/convert "$TMPIMG" \
        -filter Gaussian -resize 20% -define filter:sigma=3 -resize 500% \
        -fill "#''${BG}80" -draw "rectangle 0,0,9999,9999" \
        "$TMPIMG"

      ${pkgs.i3lock-color}/bin/i3lock \
        --image="$TMPIMG" \
        --color="$BG" \
        --inside-color="''${BG}00" \
        --ring-color="$RING" \
        --line-uses-ring \
        --keyhl-color="$ACCENT" \
        --bshl-color="$RED" \
        --separator-color="''${BG}00" \
        --insidever-color="''${ACCENT}40" \
        --ringver-color="$ACCENT" \
        --insidewrong-color="''${RED}40" \
        --ringwrong-color="$RED" \
        --verif-color="$FG" \
        --wrong-color="$RED" \
        --time-color="$FG" \
        --date-color="''${FG}80" \
        --layout-color="$FG" \
        --clock \
        --indicator \
        --time-str="%H:%M" \
        --date-str="%A, %d %B" \
        --verif-text="Verifying..." \
        --wrong-text="Wrong!" \
        --noinput-text="No Input" \
        --radius=120 \
        --ring-width=8 \
        --pass-media-keys \
        --pass-screen-keys \
        --nofork
    '';
  };

  # Hook xss-lock into the session so lock triggers on idle/suspend/lid-close
  xdg.configFile."autostart/xss-lock.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=xss-lock
    Exec=${pkgs.xss-lock}/bin/xss-lock -- ${config.home.homeDirectory}/.local/bin/lock.sh
    X-GNOME-Autostart-enabled=true
  '';

  # ───────────────────────────────────────────────────────────────
  # XFCE settings via xfconf — icons, theme, panel, xfwm
  # ───────────────────────────────────────────────────────────────
  xfconf.settings = {
    # Disable XFWM compositing — Picom handles it
    xfwm4 = {
      "general/use_compositing" = false;
      "general/title_alignment" = "center";
      "general/title_font" = "Inter Bold 10";
      "general/button_layout" = "O|HMC";         # minimize, maximize, close on the right
    };

    # Only keep panel 1 (top bar)
    xfce4-panel = {
      "panels" = [ 1 ];
      "panels/panel-1/autohide-behavior" = 0;      # never auto-hide
      "panels/panel-1/position" = "p=6;x=0;y=0";   # top, centered
      "panels/panel-1/position-locked" = true;
      "panels/panel-1/size" = 32;                   # sleek height
      "panels/panel-1/length" = 100;                # full width
      "panels/panel-1/enter-opacity" = 90;
      "panels/panel-1/leave-opacity" = 85;
      "panels/panel-1/background-style" = 0;        # let GTK/Stylix theme it
    };

    # Icon theme
    xsettings = {
      "Net/IconThemeName" = "Papirus-Dark";
    };

    # Desktop — use wallpaper from Stylix, no desktop icons for clean look
    xfce4-desktop = {
      "desktop-icons/style" = 2;                    # file/launcher icons
      "desktop-icons/icon-size" = 48;                 # clean, not too big
    };

    # Power manager — lock on lid close
    xfce4-power-manager = {
      "xfce4-power-manager/lock-screen-suspend-hibernate" = true;
      "xfce4-power-manager/logind-handle-lid-switch" = true;
    };

    # Session — use our lock script
    xfce4-session = {
      "general/LockCommand" = "${config.home.homeDirectory}/.local/bin/lock.sh";
    };
  };

  # ───────────────────────────────────────────────────────────────
  # GTK — Stylix handles the theme, we just ensure Papirus icons
  # ───────────────────────────────────────────────────────────────
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };
}
