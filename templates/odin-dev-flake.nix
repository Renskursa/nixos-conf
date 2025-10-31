# Odin development flake template
# Copy this to your Odin project directory and run: nix develop
#
# This provides a reproducible development environment with all
# libraries needed for Odin's vendor packages.

{
  description = "Odin development environment with all vendor libraries";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # All libraries needed for Odin vendor packages
        odinLibs = with pkgs; [
          # Graphics & Window Management
          raylib
          glfw
          SDL2
          SDL3
          
          # Graphics APIs
          libGL
          vulkan-loader
          vulkan-headers
          
          # Display protocols
          wayland
          wayland-protocols
          xorg.libX11
          xorg.libXcursor
          xorg.libXrandr
          xorg.libXi
          xorg.libXinerama
          
          # Audio
          portmidi
          alsa-lib
          
          # Other vendor libraries
          lua
          zlib
        ];
        
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            odin
            clang
            lldb
            gdb
            pkg-config
            gnumake
          ] ++ odinLibs;
          
          shellHook = ''
            echo "🎯 Odin Development Environment (Flake)"
            echo "========================================"
            echo "Odin: $(odin version 2>/dev/null)"
            echo ""
            echo "Ready to build with all vendor libraries!"
            echo ""
            
            # Set library paths for runtime
            export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath odinLibs}:$LD_LIBRARY_PATH"
          '';
          
          PKG_CONFIG_PATH = pkgs.lib.makeSearchPath "lib/pkgconfig" odinLibs;
        };
        
        # Optional: Add a package output for building your Odin project
        # packages.default = pkgs.stdenv.mkDerivation {
        #   pname = "my-odin-project";
        #   version = "0.1.0";
        #   src = ./.;
        #   
        #   buildInputs = [ pkgs.odin ] ++ odinLibs;
        #   
        #   buildPhase = ''
        #     odin build . -out:my-program
        #   '';
        #   
        #   installPhase = ''
        #     mkdir -p $out/bin
        #     cp my-program $out/bin/
        #   '';
        # };
      }
    );
}
