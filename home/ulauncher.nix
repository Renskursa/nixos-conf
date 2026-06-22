{ ... }:

# Tokyo Night theme for ULauncher, matching the Stylix scheme.
# After rebuild: ULauncher Preferences -> Appearance -> Color theme -> "Tokyo Night".
# (ULauncher manages its own settings.json, so the theme is selected once in the GUI.)

{
  xdg.configFile."ulauncher/user-themes/tokyo-night/manifest.json".text = builtins.toJSON {
    manifest_version = "1";
    name = "tokyo-night";
    display_name = "Tokyo Night";
    extend_theme = "dark";
    css_file = "theme.css";
    "css_file_gtk_3.20+" = "theme.css";
    matched_text_hl_colors = {
      when_selected = "#7dcfff";
      when_not_selected = "#7aa2f7";
    };
  };

  xdg.configFile."ulauncher/user-themes/tokyo-night/theme.css".text = ''
    .app {
      background-color: #1a1b26;
      border: 1px solid #414868;
      border-radius: 12px;
    }

    #input {
      background-color: #24283b;
      color: #c0caf5;
      caret-color: #7aa2f7;
      border-radius: 8px;
    }

    #result-box {
      background-color: transparent;
    }

    .selected.item-box {
      background-color: #283457;
      border-radius: 10px;
    }

    #item-name {
      color: #c0caf5;
    }

    .selected #item-name {
      color: #ffffff;
    }

    #item-descr {
      color: #565f89;
    }

    #item-shortcut {
      color: #565f89;
      background-color: rgba(65, 72, 104, 0.4);
      border: none;
      border-radius: 6px;
    }

    .selected #item-shortcut {
      color: #c0caf5;
    }
  '';
}
