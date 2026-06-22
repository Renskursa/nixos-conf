{ config, lib, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
      vulkan-validation-layers
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      nvidia-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    forceFullCompositionPipeline = false;
  };

  # NOTE: This is a hybrid Optimus laptop (Intel iGPU drives the internal
  # panel, NVIDIA dGPU is for PRIME offload). Do NOT set the offload vars
  # (__NV_PRIME_RENDER_OFFLOAD, __GLX_VENDOR_LIBRARY_NAME, GBM_BACKEND,
  # VK_ICD_FILENAMES, __VK_LAYER_NV_optimus, LIBVA_DRIVER_NAME) globally:
  # that forces the whole desktop onto the dGPU, which is not wired to the
  # panel — it black-screens X11 and wastes battery on Wayland. Those vars
  # belong in the `nvidia-offload` wrapper below, applied per-app.
  environment.sessionVariables = {
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";
    __GL_SHADER_DISK_CACHE = "1";
    __GL_THREADED_OPTIMIZATION = "1";
    # NIXOS_OZONE_WL = "1"; # Removed as it forces Wayland for Electron apps on XFCE/X11
  };

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "nvidia-offload" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '')

    (writeShellScriptBin "nvidia-performance" ''
      nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=1"
    '')

    (writeShellScriptBin "nvidia-info" ''
      nvidia-smi
      echo ""
      vulkaninfo --summary 2>/dev/null | head -20
    '')

    nvtopPackages.full
    vulkan-tools
    mesa-demos
    clinfo
  ];

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  boot.blacklistedKernelModules = [ "nouveau" ];
}
