{ config, lib, pkgs, ... }:

{
  # Enable OpenGL/Graphics
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    # RTX 3050 Mobile is Ampere architecture, so this should work.
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # RTX 3050 Mobile (Ampere) supports the open driver.
    # Set to true for better support, or false if you experience issues.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # For RTX 3050 Mobile (Ampere generation), use stable or production driver.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # PRIME configuration for hybrid graphics (laptop with Intel + Nvidia)
    prime = {
      # Offload mode - GPU sleeps when not in use, saving battery.
      # Use nvidia-offload script to run applications on Nvidia GPU.
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # Bus ID values - MUST match your system!
      # Intel iGPU: 00:02.0 -> PCI:0:2:0
      # Nvidia dGPU: 01:00.0 -> PCI:1:0:0
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Optional: Create nvidia-offload command for easy GPU offloading
  # Usage: nvidia-offload <command>
  # Example: nvidia-offload glxgears
  environment.systemPackages = with pkgs; [
    (pkgs.writeShellScriptBin "nvidia-offload" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '')
  ];
}
