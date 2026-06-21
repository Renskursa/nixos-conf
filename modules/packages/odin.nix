{ config, pkgs, ... }:

let
  # Libraries needed for Odin vendor packages
  odinLibs = with pkgs; [
    raylib
    glfw
    SDL2
    sdl3
    # GTK and related libs required by libdecor-gtk plugin
    gtk3
    cairo
    dbus
    glib
    libGL
    vulkan-loader
    wayland
    libx11
    libxcursor
    libxrandr
    libxi
    portmidi
    lua
    zlib
  ];
  
  # Wrapped Odin compiler with library paths configured
  odinWrapped = pkgs.symlinkJoin {
    name = "odin-wrapped";
    paths = [ pkgs.odin ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/odin \
        --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath odinLibs}" \
        --set-default LIBRARY_PATH "${pkgs.lib.makeLibraryPath odinLibs}"
    '';
  };
  
in {
  # Odin programming language and all required vendor libraries
  environment.systemPackages = with pkgs; [
    # Wrapped Odin compiler with library paths configured
    odinWrapped

    # All libraries are included via odinLibs in the wrapper
    # But we also add them to system packages for other tools to use
  ] ++ odinLibs ++ [
    # Additional development tools
    vulkan-headers
    wayland-protocols
    libxinerama
    alsa-lib
  ];
}
