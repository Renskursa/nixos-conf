{ config, pkgs, ... }:

{
  # Install DaVinci Resolve with proper dependencies
  environment.systemPackages = with pkgs; [
    davinci-resolve
    
    # Required libraries for video playback and GPU acceleration
    ocl-icd
    opencl-headers
    
    # Additional codec support
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
    
    # Video acceleration and codecs
    libva
    libva-utils
    vdpauinfo
    intel-media-driver
    
    # Additional libraries that DaVinci Resolve might need
    libGL
    libGLU
    xorg.libXxf86vm
    
    # Wrapper script to launch DaVinci Resolve with proper environment
    (pkgs.writeShellScriptBin "davinci-resolve-nvidia" ''
      # Ensure NVIDIA GPU is used
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      
      # OpenCL support
      export OCL_ICD_VENDORS="${pkgs.ocl-icd}/etc/OpenCL/vendors"
      
      # Disable Wayland (DaVinci Resolve works better on X11)
      export QT_QPA_PLATFORM=xcb
      
      # Force software decoding if hardware fails
      export VDPAU_DRIVER=nvidia
      
      # Launch DaVinci Resolve
      exec ${pkgs.davinci-resolve}/bin/davinci-resolve "$@"
    '')
  ];

  # Enable OpenCL for NVIDIA
  hardware.graphics = {
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
      intel-vaapi-driver
    ];
    enable32Bit = true;  # Enable 32-bit support for compatibility
  };

  # Set environment variables for DaVinci Resolve
  environment.sessionVariables = {
    # Force OpenCL to use NVIDIA
    OCL_ICD_VENDORS = "${pkgs.ocl-icd}/etc/OpenCL/vendors";
    
    # VDPAU driver for NVIDIA
    VDPAU_DRIVER = "nvidia";
    
    # LIBVA driver
    LIBVA_DRIVER_NAME = "nvidia";
    
    # GStreamer plugin paths for codec support
    GST_PLUGIN_SYSTEM_PATH_1_0 = pkgs.lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
      pkgs.gst_all_1.gst-plugins-base
      pkgs.gst_all_1.gst-plugins-good
      pkgs.gst_all_1.gst-plugins-bad
      pkgs.gst_all_1.gst-plugins-ugly
      pkgs.gst_all_1.gst-libav
      pkgs.gst_all_1.gst-vaapi
    ];
  };
}
