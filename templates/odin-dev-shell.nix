# Odin development shell template
# Copy this to your Odin project directory and run: nix-shell
#
# This provides all the libraries needed for Odin's vendor packages
# to compile and link correctly on NixOS.

{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Odin compiler
    odin
    
    # Graphics & Window Management
    raylib           # vendor:raylib - popular game library
    glfw             # vendor:glfw - OpenGL window library
    SDL2             # vendor:sdl2
    SDL3             # vendor:sdl3
    
    # Graphics APIs
    libGL            # vendor:OpenGL
    vulkan-loader    # vendor:vulkan
    vulkan-headers
    vulkan-tools     # vulkaninfo, etc.
    
    # Display protocols
    wayland          # Wayland support
    wayland-protocols
    libx11            # vendor:x11
    libxcursor
    libxrandr
    libxi
    libxinerama
    
    # Audio
    portmidi         # vendor:portmidi - MIDI library
    alsa-lib         # ALSA audio support
    
    # Other vendor libraries
    lua              # vendor:lua
    zlib             # vendor:zlib - compression
    
    # Development tools
    clang            # C compiler (Odin uses it as backend)
    lldb             # Debugger
    gdb              # Alternative debugger
    
    # Build tools
    pkg-config       # For finding library paths
    gnumake
  ];
  
  shellHook = ''
    echo "🎯 Odin Development Environment"
    echo "================================"
    echo "Odin version: $(odin version 2>/dev/null || echo 'not found')"
    echo "Odin root: $(odin root 2>/dev/null || echo 'not found')"
    echo ""
    echo "Available vendor libraries:"
    echo "  - raylib, SDL2, SDL3, GLFW"
    echo "  - OpenGL, Vulkan"
    echo "  - X11, Wayland"
    echo "  - portmidi, lua, zlib"
    echo ""
    echo "Try: odin run . (in a project directory)"
    echo "     odin build . -debug"
    echo ""
    
    # Set library path for runtime
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
      pkgs.raylib
      pkgs.glfw
      pkgs.SDL2
      pkgs.SDL3
      pkgs.libGL
      pkgs.vulkan-loader
      pkgs.wayland
      pkgs.libx11
      pkgs.libxcursor
      pkgs.libxrandr
      pkgs.libxi
      pkgs.portmidi
      pkgs.lua
      pkgs.zlib
    ]}:$LD_LIBRARY_PATH"
  '';
  
  # Set pkg-config path so Odin can find library headers
  PKG_CONFIG_PATH = with pkgs; lib.makeSearchPath "lib/pkgconfig" [
    raylib
    glfw
    SDL2
    SDL3
    vulkan-loader
    wayland
    wayland-protocols
    libx11
    portmidi
    lua
    zlib
  ];
}
