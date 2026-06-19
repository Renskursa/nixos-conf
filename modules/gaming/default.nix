{ config, pkgs, lib, ... }:

{
  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    platformOptimizations.enable = true;
    gamescopeSession.enable = true;
  };

  # Gamescope
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # GameMode
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
        softrealtime = "auto";
        ioprio = 0;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 1;
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Enabled'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Disabled'";
      };
    };
  };

  # Gaming packages
  environment.systemPackages = with pkgs; [
    # Launchers
    lutris
    heroic
    bottles
    legendary-gl
    rare
    prismlauncher

    # Streaming
    moonlight-qt

    # Proton/Wine
    protonup-qt
    winetricks
    protontricks

    # Monitoring
    mangohud
    goverlay
    vkbasalt

    # Controllers
    antimicrox
    sc-controller
    oversteer

    # Emulators
    retroarch
    dolphin-emu
    rpcs3
    pcsx2
    duckstation

    # Recording
    obs-studio
    gpu-screen-recorder

    # Misc
    vesktop
    gameconqueror
    libnotify
    lm_sensors
    corectrl
  ];

  # MangoHud config
  environment.etc."mangohud.conf".text = ''
    fps
    frametime
    gpu_stats
    gpu_temp
    cpu_stats
    cpu_temp
    ram
    vram
    gamemode
    wine
    background_alpha=0.5
    font_size=20
    position=top-left
    toggle_hud=F12
  '';

  # Kernel tweaks
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "vm.swappiness" = 10;
    "fs.file-max" = 2097152;
  };

  users.groups.gamemode = {};

  environment.sessionVariables = {
    MANGOHUD = "1";
    PROTON_ENABLE_NVAPI = "1";
    DXVK_ASYNC = "1";
  };

  # Controller udev rules
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="045e", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="054c", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="057e", MODE="0666"
    KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
  '';

  security.unprivilegedUsernsClone = true;
  hardware.graphics.enable32Bit = true;
}
